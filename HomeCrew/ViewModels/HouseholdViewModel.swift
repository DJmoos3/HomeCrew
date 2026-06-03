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
    var didCreateHousehold = false

    private let repository = HouseholdRepository()

    func createHousehold(name: String) {

        errorMessage = nil
        didCreateHousehold = false

        let trimmedName = name.trimmingCharacters(in: .whitespaces)

        guard !trimmedName.isEmpty else {
            errorMessage = "Please enter a household name"
            return
        }

        Task {
            isLoading = true

            defer {
                isLoading = false
            }

            do {
                guard let userId = Auth.auth().currentUser?.uid,
                      !userId.isEmpty else {
                    errorMessage = "User not logged in"
                    return
                }

                try await repository.createHousehold(
                    name: trimmedName,
                    userId: userId
                )

                didCreateHousehold = true

            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
