//
//  ProfileView.swift
//  HomeCrew
//
//  Created by Erik on 2026-05-20.
//

import SwiftUI

//Member Row

struct MemberRow: View {
    
    let member: Member
    
    var body: some View {
        HStack(spacing: 15) {
            
            Image(systemName: "person.crop.circle.fill")
                .font(.title2)
                .foregroundStyle(HomeCrewTheme.primaryPurple)
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text(member.name)
                    .fontWeight(.medium)
                    .foregroundStyle(HomeCrewTheme.textPrimary)
                
                Text(member.role)
                    .font(.subheadline)
                    .foregroundStyle(HomeCrewTheme.textSecondary)
            }
            
            Spacer()
        }
        .padding()
        .frame(minHeight: HomeCrewTheme.cardHeight)
        .background(HomeCrewTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: HomeCrewTheme.cornerRadius))
    }
}

//Profile View

struct ProfileView: View {
    
    //ViewModel
    @State private var viewModel = ProfileViewModel()
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 0) {
                
                //Top Bar
                HStack {
                    
                    NavigationLink {
                        EditProfileView()
                    } label: {
                        Text("Edit")
                            .fontWeight(.semibold)
                            .foregroundStyle(HomeCrewTheme.primaryPurple)
                    }
                    
                    Spacer()
                    
                    Button("Logout") {
                        
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(HomeCrewTheme.darkBlue)
                }
                .padding(.horizontal)
                .padding(.top)
                
                //Main Content
                ScrollView {
                    
                    VStack(alignment: .leading, spacing: 24) {
                        
                        //Title
                        Text("Profile")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(HomeCrewTheme.textPrimary)
                        
                        //Profile Section
                        HStack(alignment: .center, spacing: 20) {
                            
                            ZStack(alignment: .bottomTrailing) {
                                
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 90, height: 90)
                                    .foregroundStyle(HomeCrewTheme.primaryPurple.opacity(0.75))
                                
                                Button(action: {
                                    //Change profile image
                                }) {
                                    Image(systemName: "plus")
                                        .foregroundStyle(.white)
                                        .padding(8)
                                        .background(HomeCrewTheme.primaryPurple)
                                        .clipShape(Circle())
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                
                                Text(
                                    viewModel.username.isEmpty
                                    ? "No username"
                                    : viewModel.username
                                )
                                .font(.headline)
                                .foregroundStyle(HomeCrewTheme.textPrimary)
                                
                                Text(
                                    viewModel.fullName.isEmpty
                                    ? "No name set"
                                    : viewModel.fullName
                                )
                                .foregroundStyle(HomeCrewTheme.textSecondary)
                                
                                Text(
                                    viewModel.email.isEmpty
                                    ? "No email set"
                                    : viewModel.email
                                )
                                .font(.subheadline)
                                .foregroundStyle(HomeCrewTheme.textSecondary)
                            }
                            
                            Spacer()
                        }
                        
                        //Household Section
                        VStack(alignment: .leading, spacing: 15) {
                            
                            Text("Household")
                                .font(.headline)
                                .foregroundStyle(HomeCrewTheme.textPrimary)
                            
                            Text("No household yet")
                                .foregroundStyle(HomeCrewTheme.textPrimary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(HomeCrewTheme.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: HomeCrewTheme.cornerRadius))
                            
                            Button(action: {
                                //Create or join household
                            }) {
                                Text("Create / Join Household")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(HomeCrewTheme.primaryPurple)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        
                        //Member Section
                        VStack(alignment: .leading, spacing: 12) {
                            
                            Text("Members")
                                .font(.headline)
                                .foregroundStyle(HomeCrewTheme.textPrimary)
                            
                            // Empty State
                            if viewModel.members.isEmpty {
                                
                                Text("No members yet. Invite someone!")
                                    .foregroundStyle(HomeCrewTheme.textSecondary)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(HomeCrewTheme.cardBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: HomeCrewTheme.cornerRadius))
                                
                            } else {
                                
                                ForEach(viewModel.members) { member in
                                    MemberRow(member: member)
                                }
                            }
                            
                            // Invite Button
                            Button(action: {
                                viewModel.addTestMember()
                            }) {
                                Text("Invite Members")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(HomeCrewTheme.primaryPurple)
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 5)
                            }
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .background(HomeCrewTheme.background)
            .navigationBarHidden(true)
        }
    }
}

//Preview
#Preview {
    ProfileView()
}
