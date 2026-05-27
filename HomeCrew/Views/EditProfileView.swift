//
//  EditProfileView.swift
//  HomeCrew
//
//  Created by Omar Qasoma on 2026-05-21.
//

import SwiftUI


struct EditProfileView: View {
    
    // Dummy data فقط للتصميم
    @State private var fullName = "Anders Anderson"
    @State private var householdName = "The Andersons"
    @State private var taskReminder = true
    @State private var darkMode = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // HomeCrew style profile icon
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
                    
                    // Profile information
                    SectionTitle(title: "Profile Information")
                    
                    EditProfileRow(
                        icon: "person.fill",
                        iconColor: HomeCrewTheme.primaryPurple,
                        title: "Full Name",
                        subtitle: fullName,
                        showEditIcon: true
                    )
                    
                    // Household settings
                    SectionTitle(title: "Household Settings")
                    
                    EditProfileRow(
                        icon: "house.fill",
                        iconColor: HomeCrewTheme.darkBlue,
                        title: "Household Name",
                        subtitle: householdName,
                        showEditIcon: true
                    )
                    
                    EditProfileRow(
                        icon: "rectangle.portrait.and.arrow.right",
                        iconColor: HomeCrewTheme.primaryPurple,
                        title: "Leave Household",
                        subtitle: nil,
                        showEditIcon: true
                    )
                    
                    EditProfileRow(
                        icon: "trash.fill",
                        iconColor: .red,
                        title: "Delete Household",
                        subtitle: nil,
                        showEditIcon: true
                    )
                    
                    // Preferences
                    SectionTitle(title: "Preferences")
                    
                    ToggleRow(
                        icon: "bell.fill",
                        iconColor: HomeCrewTheme.darkBlue,
                        title: "Task Reminder",
                        isOn: $taskReminder
                    )
                    
                    ToggleRow(
                        icon: "moon.fill",
                        iconColor: HomeCrewTheme.primaryPurple,
                        title: "Dark Mode",
                        isOn: $darkMode
                    )
                    
                    // Log out button
                    Button {
                        // Dummy action
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
                        .clipShape(RoundedRectangle(cornerRadius: HomeCrewTheme.cornerRadius))
                    }
                    .padding(.top, 16)
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
    }
}

struct SectionTitle: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(HomeCrewTheme.textPrimary)
            
            Spacer()
        }
    }
}

struct EditProfileRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String?
    let showEditIcon: Bool
    
    var body: some View {
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
}

struct ToggleRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 18) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(iconColor)
                .frame(width: 36)
            
            Text(title)
                .font(.headline)
                .foregroundStyle(HomeCrewTheme.textPrimary)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
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
    EditProfileView()
}
