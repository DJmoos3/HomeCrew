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

    // These settings are saved locally on the device
    @AppStorage("darkModeEnabled") private var darkMode = false
    @AppStorage("taskReminderEnabled") private var taskReminder = true

    // States for editing username
    @State private var editedFullName = ""
    @State private var showNameEditor = false

    // States for editing household name
    @State private var editedHouseholdName = ""
    @State private var showHouseholdNameEditor = false

    // Alert after saving
    @State private var showSaveAlert = false

    // Gets the username from the current user
    private var displayName: String {
        authViewModel.currentUser?.username ?? "No name set"
    }

    // Gets the first letter from the username for the avatar
    private var avatarLetter: String {
        let name = displayName.trimmingCharacters(in: .whitespacesAndNewlines)

        if let firstLetter = name.first {
            return String(firstLetter).uppercased()
        }

        return "?"
    }

    // Shows the household name or a default text
    private var displayHouseholdName: String {
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

                // Opens sheet to edit the username
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

                // Opens sheet to edit the household name
                Button {
                    editedHouseholdName = displayHouseholdName
                    showHouseholdNameEditor = true
                } label: {
                    profileRow(
                        icon: "house.fill",
                        iconColor: HomeCrewTheme.darkBlue,
                        title: "Household Name",
                        subtitle: displayHouseholdName,
                        showEditIcon: true
                    )
                }
                .buttonStyle(.plain)

                profileRow(
                    icon: "rectangle.portrait.and.arrow.right",
                    iconColor: HomeCrewTheme.primaryPurple,
                    title: "Leave Household",
                    subtitle: nil,
                    showEditIcon: true
                )

                profileRow(
                    icon: "trash.fill",
                    iconColor: .red,
                    title: "Delete Household",
                    subtitle: nil,
                    showEditIcon: true
                )

                sectionTitle("Preferences")

                // Task reminder toggle
                VStack(alignment: .leading, spacing: 8) {
                    toggleRow(
                        icon: "bell.fill",
                        iconColor: HomeCrewTheme.darkBlue,
                        title: "Task Reminder",
                        isOn: $taskReminder
                    )

                    Text(
                        taskReminder
                        ? "Reminders are enabled for your assigned tasks."
                        : "Reminders are disabled."
                    )
                    .font(.caption)
                    .foregroundStyle(HomeCrewTheme.textSecondary)
                    .padding(.horizontal, 4)
                }

                // Dark mode toggle
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
        .onAppear {
            editedFullName = displayName
            loadHouseholdName()
        }
    }

    // Sheet for changing the username
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

    // Sheet for changing the household name
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

                // Shows error message if the household name cannot be saved
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

    // Loads the household name from Firebase
    private func loadHouseholdName() {
        guard let householdId = authViewModel.currentUser?.householdId else {
            return
        }

        Task {
            await householdViewModel.fetchHouseholdMembers(
                householdId: householdId
            )

            editedHouseholdName = displayHouseholdName
        }
    }

    // Saves the new household name to Firebase
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

    // Top part of the profile page
    private var profileHeader: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(HomeCrewTheme.primaryPurple)
                    .frame(width: 120, height: 120)

                // Avatar with first letter of username
                Text(avatarLetter)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(.white)

                Image(systemName: "checkmark.square.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(HomeCrewTheme.mintGreen)
                    .background(
                        Circle()
                            .fill(HomeCrewTheme.background)
                            .frame(width: 34, height: 34)
                    )
                    .offset(x: 38, y: 38)
            }

            Text("Manage your profile and household")
                .font(.subheadline)
                .foregroundStyle(HomeCrewTheme.textSecondary)
        }
        .padding(.top, 20)
    }

    // Small title for each section
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

    // Reusable row for settings with toggle
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
