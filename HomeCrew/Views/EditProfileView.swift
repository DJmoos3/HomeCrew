//
//  EditProfileView.swift
//  HomeCrew
//
//  Created by Omar Qasoma on 2026-05-21.
//

import SwiftUI

struct EditProfileView: View {

    @Environment(AuthViewModel.self) private var authViewModel
    @State private var householdViewModel = HouseholdViewModel()

    @AppStorage("darkModeEnabled") private var darkMode = false
    @AppStorage("taskReminderEnabled") private var taskReminder = true

    @State private var editedFullName = ""
    @State private var showNameEditor = false

    @State private var editedHouseholdName = ""
    @State private var showHouseholdNameEditor = false

    @State private var showSaveAlert = false

    private var displayName: String {
        authViewModel.currentUser?.username ?? "No name set"
    }

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

    private var profileHeader: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(HomeCrewTheme.primaryPurple.opacity(0.12))
                    .frame(width: 120, height: 120)

                Image(systemName: "person.2.fill")
                    .font(.system(size: 52))
                    .foregroundStyle(HomeCrewTheme.primaryPurple)

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

    private func sectionTitle(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(HomeCrewTheme.textPrimary)

            Spacer()
        }
    }

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
