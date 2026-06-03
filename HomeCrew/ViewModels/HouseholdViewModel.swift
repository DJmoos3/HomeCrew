//
//  HouseholdViewModel.swift
//  HomeCrew
//
//  Created by Urwa Adil on 2026-06-01.
//

import Foundation
import Observation
import FirebaseFirestore

@Observable
final class HouseholdViewModel {

    var isLoading: Bool = false
    var errorMessage: String? = nil
    var didCreateHousehold = false
    var members: [Member] = []
    var householdName: String = ""

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
            defer { isLoading = false }

            do {
                let authUser = try AuthRepository.shared.getUser()

                try await repository.createHousehold(
                    name: trimmedName,
                    authUser: authUser
                )

                didCreateHousehold = true

            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func fetchHouseholdMembers(householdId: String) async {
        do {
            let snapshot = try await Firestore.firestore()
                .collection("households")
                .document(householdId)
                .getDocument()

            let data = snapshot.data()
            self.householdName = data?["name"] as? String ?? ""
            
            let memberIds = data?["memberIds"] as? [String] ?? []

            // Fetch each user's document to get their username
            var fetchedMembers: [Member] = []
            for uid in memberIds {
                let userSnapshot = try await Firestore.firestore()
                    .collection("users")
                    .document(uid)
                    .getDocument()
                let username = userSnapshot.data()?["username"] as? String ?? "Unknown"
                fetchedMembers.append(Member(name: username, role: "Member"))
            }
            self.members = fetchedMembers
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    func addTestMember() {
        members.append(Member(name: "New Member", role: "Member"))
    }
}
