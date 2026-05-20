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
                    viewModel.signIn()
                }label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(Color(.white))
                        .frame(height: 50)
                        .frame(maxWidth: 100)
                        .background(Color.blue)
                        .cornerRadius(30)
                }
                .navigationDestination(isPresented: $viewModel.isSignedIn) {
                    ContentView()
                        .environmentObject(viewModel)
                }
                .padding(.horizontal, 5)
                .alert("Error", isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.errorMessage = nil } }
                )) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(viewModel.errorMessage ?? "")
                }
                
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
        .onAppear {
            viewModel.clearFields()
        }
    }
}

#Preview {
    NavigationStack{
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
