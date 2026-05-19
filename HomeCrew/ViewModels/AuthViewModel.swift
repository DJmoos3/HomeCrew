//
//  LoginViewModel.swift
//  HomeCrew
//
//  Created by Isaac Strandh on 2026-05-18.
//

import Foundation
import Combine

final class AuthViewModel : ObservableObject    {
    @Published var email = ""
    @Published var password = ""
    
    func signUp(){
        guard !email.isEmpty && !password.isEmpty else{
            print("No email or password")
            return
        }
        
        Task{
            do{
                let returnedUserData = try await AuthManager.shared.createUser(email: email, password: password)
                print("Success")
                print(returnedUserData)
            } catch{
                print("Error: \(error)")
            }
            
        }
    }
}
