//
//  LoginViewModel.swift
//  HomeCrew
//
//  Created by Isaac Strandh on 2026-05-18.
//
import FirebaseAuth
import Foundation
import Observation
import FirebaseFirestore

@Observable
@MainActor
final class AuthViewModel {
    var email = ""
    var username = ""
    var password = ""
    var currentUser: AppUser? = nil

    var errorMessage: String? = nil
    var isSignedIn: Bool = false

    private let userRepository: UserRepository
    private let householdRepository: HouseholdRepository
    

    init() {
        self.userRepository = UserRepository()
        self.householdRepository = HouseholdRepository()
    }

    func checkExistingSession() {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if !hasLaunchedBefore {
            try? Auth.auth().signOut()
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            return
        }

        if Auth.auth().currentUser != nil {
            isSignedIn = true
            Task { await fetchCurrentUser() }
        }
    }

    func clearFields() {
        email = ""
        password = ""
        errorMessage = nil
    }

    func signUp() async {
        guard !email.isEmpty && !password.isEmpty, !username.isEmpty else {
            errorMessage = "Please enter email, username and password"
            return
        }

        do {
            let returnedUserData = try await AuthRepository.shared.createUser(
                email: email,
                password: password
            )
            
            try await userRepository.createUser(authUser: returnedUserData, username: username)

            isSignedIn = true
            password = ""
            await fetchCurrentUser()
            print("Success")
        } catch {
            isSignedIn = false
            password = ""
            errorMessage = error.localizedDescription
            print("Error: \(error)")
        }
    }

    func signIn() {
        errorMessage = nil
        Task {
            do {
                try await AuthRepository.shared.signIn(email: email, password: password)
                isSignedIn = true
                await fetchCurrentUser()
            } catch let error as NSError {
                let authError = AuthErrorCode(rawValue: error.code)
                isSignedIn = false
                password = ""
                switch authError {
                case .userNotFound:
                    errorMessage = "No account found with that email"
                case .wrongPassword:
                    errorMessage = "Incorrect password"
                case .invalidEmail:
                    errorMessage = "Invalid email address"
                case .invalidCredential:
                    errorMessage = "No account found with that email or incorrect password"
                default:
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    func signOut() {
        do {
            try AuthRepository.shared.signOut()
            isSignedIn = false
            currentUser = nil
            clearFields()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func fetchCurrentUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            currentUser = try snapshot.data(as: AppUser.self)
        } catch {
            print("Error fetching user: \(error)")
        }
    }
    
    // Update username in Firestore (omar)
    func updateUsername(_ newUsername: String) async {
        guard let uid = currentUser?.id else {
            errorMessage = "Could not find current user"
            return
        }
        
        let trimmedUsername = newUsername.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedUsername.isEmpty else {
            errorMessage = "Username cannot be empty"
            return
        }
        
        do {
            try await userRepository.updateUsername(uid: uid, username: trimmedUsername)
            currentUser?.username = trimmedUsername
            username = trimmedUsername
        } catch {
            errorMessage = error.localizedDescription
            print("Error updating username: \(error)")
        }
    }
    
    // Delete user account
    func deleteAccount() async {
        errorMessage = nil

        guard let uid = Auth.auth().currentUser?.uid else {
            errorMessage = "Could not find logged in user"
            return
        }

        let householdId = currentUser?.householdId

        do {
            // First delete the account from Firebase Authentication.
            // If Firebase requires recent login, the rest will not run.
            try await AuthRepository.shared.deleteCurrentUser()

            // Then remove the user from the household if the user has one.
            if let householdId {
                try await householdRepository.removeMember(
                    householdId: householdId,
                    userId: uid
                )
            }

            // Then delete the user document from Firestore.
            try await userRepository.deleteUser(uid: uid)

            isSignedIn = false
            currentUser = nil
            clearFields()
        } catch {
            errorMessage = error.localizedDescription
            print("Error deleting account: \(error)")
        }
    }
}
