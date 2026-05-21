//
//  ProfileView.swift
//  HomeCrew
//
//  Created by Erik on 2026-05-20.
//

import SwiftUI
struct Member: Identifiable {
    let id = UUID()
    let name: String
    let role: String
}

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
    
    //User Data
       @State private var username: String = ""
       @State private var fullName: String = ""
       @State private var email: String = ""
    
    //Members
    @State private var members: [Member] = []
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 0) {
                
                //Top Bar
                HStack {
                    
                    Button("Edit") {

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
                        
                        // Title
                        Text("Profile")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        //Profile Sec
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
                                
                                Text(username.isEmpty ? "No username" : username)
                                    .font(.headline)
                                
                                Text(fullName.isEmpty ? "No name set" : fullName)
                                    .foregroundColor(.gray)
                                
                                Text(email.isEmpty ? "No email set" : email)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                        
                        //Household Section
                        VStack(alignment: .leading, spacing: 15) {
                            
                            Text("Household")
                                .font(.headline)
                            
                            Text("No household yet")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            
                            Button(action: {
                                //Create or join household
                            }) {
                                Text("Create / Join Household")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        
                        //Members Section
                        VStack(alignment: .leading, spacing: 12) {
                            
                            Text("Members")
                                .font(.headline)
                            
                            //Empty state handling
                            if members.isEmpty {
                                Text("No members yet. Invite someone!")
                                    .foregroundColor(.gray)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                            } else {
                                ForEach(members) { member in
                                    MemberRow(member: member)
                                }
                            }
                            
                            Button(action: {
                                //TEMP TEST (remove later when backend added)
                                members.append(Member(name: "New Member", role: "Member"))
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
        }
    }
}

//Preview

#Preview {
    ProfileView()
}
