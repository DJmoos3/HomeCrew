//
//  ProfileView.swift
//  HomeCrew
//
//  Created by Erik on 2026-05-20.
//

import SwiftUI

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

struct ProfileView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @State private var householdViewModel = HouseholdViewModel()

    @State private var showInviteAlert = false
    @State private var showLogoutAlert = false
    @State private var inviteEmail = ""
    
    // Avatar view
    private var displayName: String {
        authViewModel.currentUser?.username ?? "User"
    }

    private var avatarInitials: String {
        let name = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        let parts = name.split(separator: " ")

        let initials = parts
            .prefix(2)
            .compactMap { $0.first }
            .map { String($0).uppercased() }
            .joined()

        return initials.isEmpty ? "?" : initials
    }

    private var avatarColor: Color {
        let colors: [Color] = [
            .purple,
            .blue,
            .green,
            .orange,
            .pink,
            .teal,
            .indigo
        ]

        let userId = authViewModel.currentUser?.id ?? displayName
        let value = abs(userId.hashValue)

        return colors[value % colors.count]
    }
    

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {

                // Top Bar
                HStack {
                    NavigationLink {
                        EditProfileView()
                            .environment(authViewModel)
                    } label: {
                        Text("Edit")
                            .fontWeight(.semibold)
                            .foregroundStyle(HomeCrewTheme.primaryPurple)
                    }
                    Spacer()
                    Button("Logout") {
                        showLogoutAlert = true
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(HomeCrewTheme.darkBlue)
                    .alert("Log Out", isPresented: $showLogoutAlert) {
                        Button("Cancel", role: .cancel) {}
                        Button("Log Out", role: .destructive) {
                            authViewModel.signOut()
                        }
                    } message: {
                        Text("Are you sure you want to log out?")
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        Text("Profile")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(HomeCrewTheme.textPrimary)

                        // Profile Section
                        HStack(alignment: .center, spacing: 20) {
                            Circle()
                                .fill(avatarColor)
                                .frame(width: 90, height: 90)
                                .overlay {
                                    Text(avatarInitials)
                                        .font(.system(size: 34, weight: .bold))
                                        .foregroundStyle(.white)
                                }

                            VStack(alignment: .leading, spacing: 5) {
                                Text(
                                    authViewModel.currentUser?.username
                                        ?? "No username"
                                )
                                .font(.headline)
                                .foregroundStyle(HomeCrewTheme.textPrimary)
                                Text(
                                    authViewModel.currentUser?.email
                                        ?? "No email set"
                                )
                                .font(.subheadline)
                                .foregroundStyle(HomeCrewTheme.textSecondary)
                            }
                            Spacer()
                        }

                        // Household Section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Household")
                                .font(.headline)
                                .foregroundStyle(HomeCrewTheme.textPrimary)
                            
                            Text(
                                householdViewModel.householdName.isEmpty
                                ? "No household yet"
                                : householdViewModel.householdName
                            )
                            .foregroundStyle(HomeCrewTheme.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(HomeCrewTheme.cardBackground)
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: HomeCrewTheme.cornerRadius
                                )
                            )
                            
                            if authViewModel.currentUser?.householdId == nil || authViewModel.currentUser?.householdId?.isEmpty == true {
                                NavigationLink {
                                    CreateHouseholdView()
                                        .environment(authViewModel)
                                } label: {
                                    Text("Create / Join Household")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(HomeCrewTheme.primaryPurple)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }

                        // Member Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Members")
                                .font(.headline)
                                .foregroundStyle(HomeCrewTheme.textPrimary)

                            if householdViewModel.members.isEmpty {
                                Text("No members yet. Invite someone!")
                                    .foregroundStyle(
                                        HomeCrewTheme.textSecondary
                                    )
                                    .padding()
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )
                                    .background(HomeCrewTheme.cardBackground)
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: HomeCrewTheme
                                                .cornerRadius
                                        )
                                    )
                            } else {
                                ForEach(householdViewModel.members) { member in
                                    MemberRow(member: member)
                                }
                            }

                            Button(action: {
                                showInviteAlert = true
                            }) {
                                Text("Invite Members")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(
                                        HomeCrewTheme.primaryPurple
                                    )
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 5)
                            }
                            .alert(
                                "Invite Member",
                                isPresented: $showInviteAlert
                            ) {
                                @Bindable var householdViewModel =
                                    householdViewModel
                                TextField(
                                    "Email",
                                    text: $householdViewModel.inviteEmail
                                )
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                Button("Cancel", role: .cancel) {
                                    householdViewModel.inviteEmail = ""
                                }
                                Button("Send Invite") {
                                    Task {
                                        guard
                                            let householdId = authViewModel
                                                .currentUser?.householdId
                                        else {
                                            householdViewModel.errorMessage =
                                                "You need to create or join a household first"
                                            return
                                        }
                                        
                                        // TODO: Invite member or add member to household for testing
//                                        await householdViewModel.inviteMember(
//                                            householdId: householdId
//                                        )
                                        
                                        await householdViewModel.addMemberDirectly(
                                            householdId: householdId
                                        )
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                Spacer()
            }
            .background(HomeCrewTheme.background)
            .navigationBarHidden(true)
            .onAppear {
                Task {
                    await authViewModel.fetchCurrentUser()
                    if let householdId = authViewModel.currentUser?.householdId
                    {
                        await householdViewModel.fetchHouseholdMembers(
                            householdId: householdId
                        )
                    }
                }
            }
        }
        .alert("Error", isPresented: Binding(
            get: { householdViewModel.errorMessage != nil },
            set: { if !$0 { householdViewModel.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(householdViewModel.errorMessage ?? "")
        }
    }
}

#Preview {
    ProfileView()
        .environment(AuthViewModel())
}
