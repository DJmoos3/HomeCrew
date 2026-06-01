//
//  CreateHouseholdView.swift
//  HomeCrew
//
//  Created by Urwa Adil on 2026-06-01.
//
import SwiftUI

struct CreateHouseholdView: View {

    @State private var viewModel = HouseholdViewModel()
    @State private var householdName: String = ""

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 16) {

                    // MARK: Header
                    VStack(spacing: 10) {

                        ZStack {

                            Circle()
                                .fill(HomeCrewTheme.primaryPurple.opacity(0.12))
                                .frame(width: 110, height: 110)

                            Image(systemName: "house.fill")
                                .font(.system(size: 46))
                                .foregroundStyle(HomeCrewTheme.primaryPurple)

                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(HomeCrewTheme.mintGreen)
                                .offset(x: 34, y: 34)
                        }

                        Text("Create a new household")
                            .font(.subheadline)
                            .foregroundStyle(HomeCrewTheme.textSecondary)
                    }
                    .padding(.top, 20)

                    // MARK: Input Card
                    VStack(alignment: .leading, spacing: 12) {

                        Text("Household name")
                            .font(.headline)
                            .foregroundStyle(HomeCrewTheme.textPrimary)

                        TextField("e.g. HomeCrew House", text: $householdName)
                            .padding()
                            .background(HomeCrewTheme.cardBackground)
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: HomeCrewTheme.cornerRadius
                                )
                            )

                        if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                    .padding()
                    .background(HomeCrewTheme.cardBackground)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: HomeCrewTheme.cornerRadius
                        )
                    )

                    // MARK: Button
                    Button {
                        Task {
                            await viewModel.createHousehold(name: householdName)
                        }
                    } label: {

                        HStack {

                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Create Household")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                            }

                            Spacer()

                            Image(systemName: "arrow.right")
                                .foregroundStyle(.white)
                        }
                        .padding()
                        .frame(minHeight: HomeCrewTheme.cardHeight)
                        .background(HomeCrewTheme.primaryPurple)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: HomeCrewTheme.cornerRadius
                            )
                        )
                    }
                    .disabled(
                        householdName.trimmingCharacters(in: .whitespaces).isEmpty ||
                        viewModel.isLoading
                    )

                }
                .padding()
            }
            .background(HomeCrewTheme.background)
            .navigationTitle("Household")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CreateHouseholdView()
}
