//
//  LoginViewModel.swift
//  HomeCrew
//
//  Created by Isaac Strandh on 2026-05-18.
//

import Foundation
import Combine
import FirebaseAuth

final class AuthViewModel : ObservableObject    {
    @Published var email = ""
    @Published var password = ""
    
    @Published var errorMessage: String? = nil
    @Published var isSignedIn: Bool = false
    
    
    func clearFields() {
        email = ""
        password = ""
        isSignedIn = false
    }
    
    
    func signUp(){
        guard !email.isEmpty && !password.isEmpty else{
            print("No email or password")
            return
        }
        
        Task{
            do{
                let returnedUserData = try await AuthManager.shared.createUser(email: email, password: password)
                isSignedIn = true
                print("Success")
                print(returnedUserData)
            } catch{
                print("Error: \(error)")
            }
            
        }
    }
    
    func signIn() {
        errorMessage = nil
        Task {
            do {
                try await AuthManager.shared.signIn(email: email, password: password)
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
                    errorMessage = "No account found with that email or incorrect password"
                default:
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
