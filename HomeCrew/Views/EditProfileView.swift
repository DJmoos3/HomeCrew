//
//  EditProfileView.swift
//  HomeCrew
//
//  Created by Omar Qasoma on 2026-05-21.
//

import SwiftUI

struct EditProfileView: View {

    // ViewModel for the logged in user
    @Environment(AuthViewModel.self) private var authViewModel

    // ViewModel for household data
    @State private var householdViewModel = HouseholdViewModel()

    // Local settings saved on the device
    @AppStorage("darkModeEnabled") private var darkMode = false

    // Username edit
    @State private var editedFullName = ""
    @State private var showNameEditor = false

    // Household name edit
    @State private var editedHouseholdName = ""
    @State private var showHouseholdNameEditor = false

    // Alerts
    @State private var showSaveAlert = false
    @State private var showDeleteAccountAlert = false
    @State private var showLeaveHouseholdAlert = false

    // Current username
    private var displayName: String {
        authViewModel.currentUser?.username ?? "No name set"
    }

    // Initials for the profile avatar.
    // This uses the same idea as the chat avatar.
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

    // Color for the profile avatar.
    // The color is based on the user id, so it stays the same for the same user.
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

    // Current household name
    private var displayHouseholdName: String {
        if authViewModel.currentUser?.householdId == nil {
            return "No household set"
        }

        if householdViewModel.householdName.isEmpty {
            return "No household set"
        }

        return householdViewModel.householdName
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                profileHeader

                sectionTitle("Profile Information")

                Button {
                    editedFullName = displayName
                    showNameEditor = true
                } label: {
                    profileRow(
                        icon: "person.fill",
                        iconColor: HomeCrewTheme.primaryPurple,
                        title: "Full Name",
                        subtitle: displayName,
                        showEditIcon: true
                    )
                }
                .buttonStyle(.plain)

                sectionTitle("Household Settings")

                Button {
                    editedHouseholdName = displayHouseholdName
                    showHouseholdNameEditor = true
                } label: {
                    profileRow(
                        icon: "house.fill",
                        iconColor: HomeCrewTheme.darkBlue,
                        title: "Household Name",
                        subtitle: displayHouseholdName,
                        showEditIcon: authViewModel.currentUser?.householdId != nil
                    )
                }
                .buttonStyle(.plain)
                .disabled(authViewModel.currentUser?.householdId == nil)
                .opacity(authViewModel.currentUser?.householdId == nil ? 0.5 : 1)

                Button {
                    showLeaveHouseholdAlert = true
                } label: {
                    profileRow(
                        icon: "rectangle.portrait.and.arrow.right",
                        iconColor: HomeCrewTheme.primaryPurple,
                        title: "Leave Household",
                        subtitle: authViewModel.currentUser?.householdId == nil ? "No household to leave" : nil,
                        showEditIcon: authViewModel.currentUser?.householdId != nil
                    )
                }
                .buttonStyle(.plain)
                .disabled(authViewModel.currentUser?.householdId == nil)
                .opacity(authViewModel.currentUser?.householdId == nil ? 0.5 : 1)

                Button {
                    showDeleteAccountAlert = true
                } label: {
                    profileRow(
                        icon: "trash.fill",
                        iconColor: .red,
                        title: "Delete My Account",
                        subtitle: "This action cannot be undone",
                        showEditIcon: true
                    )
                }
                .buttonStyle(.plain)

                sectionTitle("Preferences")

                toggleRow(
                    icon: "moon.fill",
                    iconColor: HomeCrewTheme.primaryPurple,
                    title: "Dark Mode",
                    isOn: $darkMode
                )
            }
            .padding()
        }
        .background(HomeCrewTheme.background)
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            editedFullName = displayName
            loadHouseholdName()
        }
        .sheet(isPresented: $showNameEditor) {
            editNameSheet
        }
        .sheet(isPresented: $showHouseholdNameEditor) {
            editHouseholdNameSheet
        }
        .alert("Profile updated", isPresented: $showSaveAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your profile settings have been saved.")
        }
        .alert("Delete account?", isPresented: $showDeleteAccountAlert) {
            Button("Cancel", role: .cancel) { }

            Button("Delete", role: .destructive) {
                Task {
                    await authViewModel.deleteAccount()
                }
            }
        } message: {
            Text("Are you sure you want to delete your account?")
        }
        .alert("Leave household?", isPresented: $showLeaveHouseholdAlert) {
            Button("Cancel", role: .cancel) { }

            Button("Leave", role: .destructive) {
                Task {
                    await authViewModel.leaveHousehold()
                    householdViewModel.householdName = ""
                    editedHouseholdName = "No household set"
                }
            }
        } message: {
            Text("Are you sure you want to leave this household?")
        }
    }

    // Sheet for changing username
    private var editNameSheet: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Full name", text: $editedFullName)
                    .padding()
                    .background(HomeCrewTheme.cardBackground)
                    .foregroundStyle(HomeCrewTheme.textPrimary)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: HomeCrewTheme.cornerRadius
                        )
                    )
                    .padding(.horizontal)

                Spacer()
            }
            .padding(.top)
            .background(HomeCrewTheme.background)
            .navigationTitle("Edit Name")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        editedFullName = displayName
                        showNameEditor = false
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                            await authViewModel.updateUsername(editedFullName)
                            editedFullName = displayName
                            showNameEditor = false
                            showSaveAlert = true
                        }
                    }
                }
            }
        }
    }

    // Sheet for changing household name
    private var editHouseholdNameSheet: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Household name", text: $editedHouseholdName)
                    .padding()
                    .background(HomeCrewTheme.cardBackground)
                    .foregroundStyle(HomeCrewTheme.textPrimary)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: HomeCrewTheme.cornerRadius
                        )
                    )
                    .padding(.horizontal)

                if let errorMessage = householdViewModel.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.top)
            .background(HomeCrewTheme.background)
            .navigationTitle("Edit Household")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        editedHouseholdName = displayHouseholdName
                        showHouseholdNameEditor = false
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveHouseholdName()
                    }
                }
            }
        }
    }

    // Load household name when the page opens
    private func loadHouseholdName() {
        guard let householdId = authViewModel.currentUser?.householdId else {
            householdViewModel.householdName = ""
            editedHouseholdName = "No household set"
            return
        }

        Task {
            await householdViewModel.fetchHouseholdMembers(
                householdId: householdId
            )

            editedHouseholdName = displayHouseholdName
        }
    }

    // Save new household name to Firebase
    private func saveHouseholdName() {
        guard let householdId = authViewModel.currentUser?.householdId else {
            householdViewModel.errorMessage = "Could not find household"
            return
        }

        Task {
            await householdViewModel.updateHouseholdName(
                householdId: householdId,
                newName: editedHouseholdName
            )

            if householdViewModel.errorMessage == nil {
                editedHouseholdName = displayHouseholdName
                showHouseholdNameEditor = false
                showSaveAlert = true
            }
        }
    }

    // Top profile area
    private var profileHeader: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(avatarColor)
                    .frame(width: 120, height: 120)

                // Avatar with initials, similar to chat avatar
                Text(avatarInitials)
                    .font(.system(size: 42, weight: .bold))
                    .foregroundStyle(.white)
            }

            Text("Manage your profile and household")
                .font(.subheadline)
                .foregroundStyle(HomeCrewTheme.textSecondary)
        }
        .padding(.top, 20)
    }

    // Title for each section
    private func sectionTitle(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(HomeCrewTheme.textPrimary)

            Spacer()
        }
    }

    // Reusable row for profile settings
    private func profileRow(
        icon: String,
        iconColor: Color,
        title: String,
        subtitle: String?,
        showEditIcon: Bool
    ) -> some View {
        HStack(spacing: 18) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(iconColor)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(HomeCrewTheme.textPrimary)

                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(HomeCrewTheme.textSecondary)
                }
            }

            Spacer()

            if showEditIcon {
                Image(systemName: "square.and.pencil")
                    .font(.title3)
                    .foregroundStyle(HomeCrewTheme.darkBlue)
            }
        }
        .padding()
        .frame(minHeight: HomeCrewTheme.cardHeight)
        .background(HomeCrewTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: HomeCrewTheme.cornerRadius))
    }

    // Reusable row with toggle
    private func toggleRow(
        icon: String,
        iconColor: Color,
        title: String,
        isOn: Binding<Bool>
    ) -> some View {
        HStack(spacing: 18) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(iconColor)
                .frame(width: 36)

            Text(title)
                .font(.headline)
                .foregroundStyle(HomeCrewTheme.textPrimary)

            Spacer()

            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(HomeCrewTheme.mintGreen)
        }
        .padding()
        .frame(minHeight: HomeCrewTheme.cardHeight)
        .background(HomeCrewTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: HomeCrewTheme.cornerRadius))
    }
}

#Preview {
    NavigationStack {
        EditProfileView()
            .environment(AuthViewModel())
    }
}
