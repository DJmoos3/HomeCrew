//
//  HouseholdViewModel.swift
//  HomeCrew
//
//  Created by Urwa Adil on 2026-06-01.
//

import FirebaseFirestore
import Foundation
import Observation

@Observable
@MainActor
final class HouseholdViewModel {

    var isLoading: Bool = false
    var errorMessage: String? = nil
    var didCreateHousehold = false

    var members: [Member] = []
    var householdName: String = ""
    var inviteEmail = ""

    private let repository = HouseholdRepository()
    private let authRepository: AuthRepository = .shared

    func createHousehold(name: String) async {
        errorMessage = nil
        didCreateHousehold = false

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            errorMessage = "Please enter a household name"
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let authUser = try authRepository.getUser()
            try await repository.createHousehold(
                name: trimmedName,
                authUser: authUser
            )
            didCreateHousehold = true

        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func fetchHouseholdMembers(householdId: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let household = try await repository.fetchHousehold(
                householdId: householdId
            )
            householdName = household.name
            members = try await repository.fetchMembers(
                memberIds: household.memberIds
            )
        } catch {
            errorMessage = error.localizedDescription
        }

        /*
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
                let username =
                    userSnapshot.data()?["username"] as? String ?? "Unknown"
                fetchedMembers.append(Member(name: username, role: "Member"))
            }
            self.members = fetchedMembers
        } catch {
            errorMessage = error.localizedDescription
        }

        */
    }

    //    func addTestMember() {
    //        members.append(Member(name: "New Member", role: "Member"))
    //    }

    func inviteMember(householdId: String) async {
        let email = inviteEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        print("Email \(email)")
        guard !email.isEmpty else {
            errorMessage = "Please enter an email"
            return
        }

        do {
            let authUser = try authRepository.getUser()
            try await repository.inviteMember(
                householdId: householdId,
                invitedEmail: email,
                invitedByUserId: authUser.uid
            )
            inviteEmail = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func removeMember(householdId: String, userId: String) async {
        do {
            try await repository.removeMember(
                householdId: householdId,
                userId: userId
            )
            await fetchHouseholdMembers(householdId: householdId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func addMemberDirectly(householdId: String) async {
        let email = inviteEmail.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !email.isEmpty else {
            errorMessage = "Please enter an email"
            return
        }

        do {
            try await repository.addMemberDirectly(
                householdId: householdId,
                email: email
            )
            inviteEmail = ""
            await fetchHouseholdMembers(householdId: householdId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func updateHouseholdName(householdId: String, newName: String) async {
        errorMessage = nil

        let trimmedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            errorMessage = "Please enter a household name"
            return
        }

        do {
            try await repository.updateHouseholdName(
                householdId: householdId,
                name: trimmedName
            )

            householdName = trimmedName
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
