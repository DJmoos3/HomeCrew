//
//  HouseholdViewModel.swift
//  HomeCrew
//
//  Created by Urwa Adil on 2026-06-01.
//

import Foundation
import FirebaseAuth
import Observation

@Observable
final class HouseholdViewModel {

    var isLoading: Bool = false
    var errorMessage: String? = nil

    private let repository = HouseholdRepository()

    func createHousehold(name: String) {

        errorMessage = nil

        let trimmedName = name.trimmingCharacters(in: .whitespaces)

        if trimmedName.isEmpty {
            errorMessage = "Please enter a household name"
            return
        }

        isLoading = true

        Task {
            do {
                let userId = Auth.auth().currentUser?.uid ?? ""

                if userId.isEmpty {
                    errorMessage = "User not logged in"
                    isLoading = false
                    return
                }

                try await repository.createHousehold(
                    name: trimmedName,
                    userId: userId
                )

            } catch {
                errorMessage = error.localizedDescription
            }

            isLoading = false
        }
    }
}

