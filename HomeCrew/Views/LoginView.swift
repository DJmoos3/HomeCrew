//
//  LoginView.swift
//  HomeCrew
//
//  Created by Isaac Strandh on 2026-05-18.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(AuthViewModel.self) private var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
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
                        .environment(viewModel)
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
                        .environment(viewModel)
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
            .environment(AuthViewModel())
    }
}
