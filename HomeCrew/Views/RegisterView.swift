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

        NavigationStack {

            VStack(spacing: 20) {

                //Header
                VStack(spacing: 10) {

                    ZStack {

                        //Background circle
                        Circle()
                            .fill(HomeCrewTheme.primaryPurple.opacity(0.12))
                            .frame(width: 110, height: 110)

                        // App logo from Assets
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 45))
    
                    }

                    Text("Create your HomeCrew account")
                        .font(.subheadline)
                        .foregroundStyle(HomeCrewTheme.textSecondary)
                }
                .padding(.top, 20)

                //Email
                VStack(alignment: .leading, spacing: 8) {

                    Text("Email")
                        .font(.headline)
                        .foregroundStyle(HomeCrewTheme.textPrimary)

                    TextField("Email...", text: $viewModel.email)
                        .padding()
                        .background(HomeCrewTheme.primaryPurple.opacity(0.12))
                        .foregroundStyle(HomeCrewTheme.textPrimary)
                        .clipShape(
                            RoundedRectangle(cornerRadius: HomeCrewTheme.cornerRadius)
                        )
                }

                //Password
                VStack(alignment: .leading, spacing: 8) {

                    Text("Password")
                        .font(.headline)
                        .foregroundStyle(HomeCrewTheme.textPrimary)

                    SecureField("Password...", text: $viewModel.password)
                        .padding()
                        .background(HomeCrewTheme.primaryPurple.opacity(0.12))
                        .foregroundStyle(HomeCrewTheme.textPrimary)
                        .clipShape(
                            RoundedRectangle(cornerRadius: HomeCrewTheme.cornerRadius)
                        )

                    Text("Minimum 6 characters")
                        .font(.subheadline)
                        .foregroundStyle(HomeCrewTheme.textSecondary)
                }

                //Register Button
                Button {
                    viewModel.signUp()
                } label: {

                    Text("Register")
                        .font(.headline)
                        .foregroundStyle(HomeCrewTheme.background)
                        .frame(maxWidth: .infinity)
                        .frame(height: HomeCrewTheme.cardHeight)
                        .background(HomeCrewTheme.primaryPurple)
                        .clipShape(
                            RoundedRectangle(cornerRadius: HomeCrewTheme.cornerRadius)
                        )
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding()
            .background(HomeCrewTheme.background)

            //Navigation after signup
            .navigationDestination(isPresented: $viewModel.isSignedIn) {
                ContentView()
                    .environmentObject(viewModel)
            }

            //Reset fields when view appears
            .onAppear {
                viewModel.clearFields()
            }
        }
    }
}

#Preview {
        RegisterView()
            .environmentObject(AuthViewModel())
    }

