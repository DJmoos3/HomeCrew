//
//  LoginViewModel.swift
//  HomeCrew
//
//  Created by Isaac Strandh on 2026-05-18.
//

import FirebaseAuth
import Foundation
import Observation

@Observable
@MainActor
final class AuthViewModel {
    var email = ""
    var username = ""
    var password = ""

    var errorMessage: String? = nil
    var isSignedIn: Bool = false

    private let userRepository: UserRepository

    init() {
        self.userRepository = UserRepository()
    }

    func clearFields() {
        email = ""
        password = ""
        isSignedIn = false
        errorMessage = nil
    }

    func signUp() async {
        guard !email.isEmpty && !password.isEmpty, !username.isEmpty else {
            errorMessage = "Please enter email, username and password"
            print("Please enter email, username and password")
            return
        }

        do {
            let returnedUserData = try await AuthManager.shared.createUser(
                email: email,
                password: password
            )
            
            try await userRepository.createUser(authUser: returnedUserData, username: username)

            isSignedIn = true
            password = ""
            print("Success")
            print(returnedUserData)
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
                try await AuthManager.shared.signIn(
                    email: email,
                    password: password
                )
                isSignedIn = true
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
                    errorMessage =
                        "No account found with that email or incorrect password"
                default:
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
