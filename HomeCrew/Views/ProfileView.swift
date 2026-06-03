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
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text(member.name)
                    .fontWeight(.medium)
                
                Text(member.role)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

//Profile View

struct ProfileView: View {
    
    //ViewModel
    @State private var viewModel = ProfileViewModel()
//    @State private var householdName: String?
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 0) {
                
                //Top Bar
                HStack {
                    
                    NavigationLink {

                    EditProfileView()

                 } label: {

                   Text("Edit")

                }
                    
                    Spacer()
                    
                    Button("Logout") {
                        
                    }
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
                        
                        //Profile Section
                        HStack(alignment: .center, spacing: 20) {
                            
                            ZStack(alignment: .bottomTrailing) {
                                
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 90, height: 90)
                                    .foregroundColor(.gray)
                                
                                Button(action: {
                                    //Change profile image
                                }) {
                                    Image(systemName: "plus")
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(Color.purple)
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
                                
                                Text(
                                    viewModel.fullName.isEmpty
                                    ? "No name set"
                                    : viewModel.fullName
                                )
                                .foregroundColor(.gray)
                                
                                Text(
                                    viewModel.email.isEmpty
                                    ? "No email set"
                                    : viewModel.email
                                )
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                        
                        //Household Section
                        VStack(alignment: .leading, spacing: 15) {
                            
                            Text("Household")
                                .font(.headline)
                            //Updated the household name
                            Text(
                                viewModel.householdName.isEmpty
                                ? "No household yet"
                                :viewModel.householdName
                            )
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            
                            NavigationLink{
                                CreateHouseholdView(profileViewModel: viewModel)
//                                { name in
//                                    householdName = name
//                                }
                      
                            } label: {
                                Text("Create / Join Household")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        
                        //Member Section
                        VStack(alignment: .leading, spacing: 12) {
                            
                            Text("Members")
                                .font(.headline)
                            
                            //Empty State
                            if viewModel.members.isEmpty {
                                
                                Text("No members yet. Invite someone!")
                                    .foregroundColor(.gray)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                
                            } else {
                                
                                ForEach(viewModel.members) { member in
                                    MemberRow(member: member)
                                }
                            }
                            
                            //Invite Button
                            Button(action: {
                                viewModel.addTestMember()
                            }) {
                                Text("Invite Members")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 5)
                            }
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
            .onAppear {
                Task{
                    await viewModel.fetchUser()
                }
            }
        }
    }
}

//Preview

#Preview {
    ProfileView()
}
