//
//  LoginView.swift
//  HomeCrew
//
//  Created by Isaac Strandh on 2026-05-18.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    private enum Field {
        case email
        case password
    }
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: focusedField == nil ? 24 : 12) {
                    
                    Spacer(minLength: focusedField == nil ? 70 : 10)
                    
                    // Logo
                    VStack(spacing: 8) {
                        Image("HomeCrewLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: focusedField == nil ? 200 : 70,
                                height: focusedField == nil ? 200 : 70
                            )
                        
                        if focusedField == nil {
                            Text("Sign in to manage your household")
                                .font(.subheadline)
                                .foregroundStyle(HomeCrewTheme.textSecondary)
                        }
                    }
                    .padding(.bottom, focusedField == nil ? 16 : 4)
                    
                    // Input fields
                    VStack(spacing: 14) {
                        TextField("Email...", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .submitLabel(.next)
                            .focused($focusedField, equals: .email)
                            .onSubmit {
                                focusedField = .password
                            }
                            .padding()
                            .background(HomeCrewTheme.cardBackground)
                            .foregroundStyle(HomeCrewTheme.textPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: HomeCrewTheme.cornerRadius))
                        
                        SecureField("Password...", text: $viewModel.password)
                            .submitLabel(.done)
                            .focused($focusedField, equals: .password)
                            .onSubmit {
                                viewModel.signIn()
                            }
                            .padding()
                            .background(HomeCrewTheme.cardBackground)
                            .foregroundStyle(HomeCrewTheme.textPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: HomeCrewTheme.cornerRadius))
                    }
                    
                    // Buttons
                    HStack(spacing: 12) {
                        Button {
                            viewModel.signIn()
                        } label: {
                            Text("Sign In")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(HomeCrewTheme.primaryPurple)
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                        }
                        .navigationDestination(isPresented: $viewModel.isSignedIn) {
                            ContentView()
                                .environmentObject(viewModel)
                        }
                        .alert("Error", isPresented: Binding(
                            get: { viewModel.errorMessage != nil },
                            set: { if !$0 { viewModel.errorMessage = nil } }
                        )) {
                            Button("OK", role: .cancel) { }
                        } message: {
                            Text(viewModel.errorMessage ?? "")
                        }
                        
                        NavigationLink {
                            RegisterView()
                                .environmentObject(viewModel)
                        } label: {
                            Text("Sign Up")
                                .font(.headline)
                                .foregroundStyle(HomeCrewTheme.primaryPurple)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(HomeCrewTheme.primaryPurple.opacity(0.12))
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                        }
                    }
                    .id("buttons")
                    
                    Spacer(minLength: focusedField == nil ? 70 : 20)
                }
                .padding()
            }
            .background(HomeCrewTheme.background)
            .navigationTitle("Sign In")
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: focusedField) {
                if focusedField == .password {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation {
                            proxy.scrollTo("buttons", anchor: .bottom)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.clearFields()
                focusedField = nil
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
