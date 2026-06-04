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
    @State private var inviteEmail = ""

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
                    Button("Logout") {}
                        .fontWeight(.semibold)
                        .foregroundStyle(HomeCrewTheme.darkBlue)
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
                            ZStack(alignment: .bottomTrailing) {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 90, height: 90)
                                    .foregroundStyle(
                                        HomeCrewTheme.primaryPurple.opacity(
                                            0.75
                                        )
                                    )
                                Button(action: {}) {
                                    Image(systemName: "plus")
                                        .foregroundStyle(.white)
                                        .padding(8)
                                        .background(HomeCrewTheme.primaryPurple)
                                        .clipShape(Circle())
                                }
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

                            NavigationLink {
                                CreateHouseholdView()
                                    .environment(authViewModel)
                            } label: {
                                Text("Create / Join Household")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(
                                        HomeCrewTheme.primaryPurple
                                    )
                                    .frame(maxWidth: .infinity)
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
    }
}

#Preview {
    ProfileView()
        .environment(AuthViewModel())
}
