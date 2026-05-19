//
//  LoginView.swift
//  HomeCrew
//
//  Created by Isaac Strandh on 2026-05-18.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack{
            
            TextField("Email...", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            SecureField("Pasword...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            HStack{
                Button{
                    
                }label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(Color(.white))
                        .frame(height: 50)
                        .frame(maxWidth: 100)
                        .background(Color.blue)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 5)
                
                NavigationLink{
                    RegisterView()
                        .environmentObject(viewModel)
                } label: {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(Color(.white))
                        .frame(height: 50)
                        .frame(maxWidth: 100)
                        .background(Color.blue)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 5)
            }
        }
        .navigationTitle("Sign In")
    }
}

#Preview {
    NavigationStack{
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
