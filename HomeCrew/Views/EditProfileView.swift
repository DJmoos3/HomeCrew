//
//  EditProfileView.swift
//  HomeCrew
//
//  Created by Omar Qasoma on 2026-05-21.
//

import SwiftUI

struct EditProfileView: View {

    // Dummy data for design only
    @State private var fullName = "Anders Anderson"
    @State private var householdName = "The Andersons"
    @AppStorage("darkModeEnabled") private var darkMode = false
    @AppStorage("taskReminderEnabled") private var taskReminder = true

    var body: some View {

        ScrollView {
            VStack(spacing: 24) {

                profileHeader

                sectionTitle("Profile Information")

                profileRow(
                    icon: "person.fill",
                    iconColor: HomeCrewTheme.primaryPurple,
                    title: "Full Name",
                    subtitle: fullName,
                    showEditIcon: true
                )

                sectionTitle("Household Settings")

                profileRow(
                    icon: "house.fill",
                    iconColor: HomeCrewTheme.darkBlue,
                    title: "Household Name",
                    subtitle: householdName,
                    showEditIcon: true
                )

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

                toggleRow(
                    icon: "bell.fill",
                    iconColor: HomeCrewTheme.darkBlue,
                    title: "Task Reminder",
                    isOn: $taskReminder
                )

                toggleRow(
                    icon: "moon.fill",
                    iconColor: HomeCrewTheme.primaryPurple,
                    title: "Dark Mode",
                    isOn: $darkMode
                )

                logoutButton
            }
            .padding()
        }
        .background(HomeCrewTheme.background)
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    // Dummy save action
                }
                .font(.headline)
                .foregroundStyle(HomeCrewTheme.primaryPurple)
            }
        }
    }

    // MARK: - Profile Header
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

    // MARK: - Section Title
    private func sectionTitle(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(HomeCrewTheme.textPrimary)

            Spacer()
        }
    }

    // MARK: - Profile Row
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

    // MARK: - Toggle Row
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

    // MARK: - Log Out Button
    private var logoutButton: some View {
        Button {
            // Dummy logout action
        } label: {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.title2)

                Spacer()

                Text("Log Out")
                    .font(.headline)

                Spacer()
            }
            .padding()
            .frame(height: HomeCrewTheme.cardHeight)
            .background(HomeCrewTheme.cardBackground)
            .foregroundStyle(HomeCrewTheme.darkBlue)
            .clipShape(
                RoundedRectangle(cornerRadius: HomeCrewTheme.cornerRadius)
            )
        }
        .padding(.top, 16)
    }
}

#Preview {
    NavigationStack {
        EditProfileView()
    }
}
