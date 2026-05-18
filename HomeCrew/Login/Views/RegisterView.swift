//
//  RegisterView.swift
//  HomeCrew
//
//  Created by Isaac Strandh on 2026-05-18.
//

import SwiftUI

struct RegisterView: View {
    
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
            Button{
                viewModel.signUp()
            }label: {
                Text("Register")
                    .font(.headline)
                    .foregroundColor(Color(.white))
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    NavigationStack{
        RegisterView()
            .environmentObject(AuthViewModel())
    }
}
