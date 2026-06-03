//
//  HouseholdRepository.swift
//  HomeCrew
//
//  Created by Isaac Strandh on 2026-05-28.
//

import FirebaseFirestore
import Foundation

final class HouseholdRepository {
    private lazy var db = Firestore.firestore()

    func createHousehold(name: String, authUser: AuthDataResultModel)
        async throws
    {
        let household = Household(
            name: name,
            memberIds: [authUser.uid],
            createdBy: authUser.uid,
            createdAt: Date()
        )
        let ref = try db.collection("households").addDocument(from: household)
        try await db.collection("users").document(authUser.uid).updateData([
            "householdId": ref.documentID
        ])
    }

    func fetchHousehold(householdId: String) async throws -> Household {
        try await db.collection("households").document(householdId)
            .getDocument(as: Household.self)
    }

    func fetchMembers(memberIds: [String]) async throws -> [Member] {
        var members: [Member] = []

        for uid in memberIds {
            let snapshot = try await db.collection("users")
                .document(uid)
                .getDocument()
            let data = snapshot.data()
            let member = Member(
                id: uid,
                name: data?["username"] as? String ?? "Unknown",
                email: data?["email"] as? String ?? "",
                role: "Member"
            )
            members.append(member)
        }
        return members
    }

    func inviteMember(
        householdId: String,
        invitedEmail: String,
        invitedByUserId: String
    ) async throws {
        let invite = HouseholdInvite(
            householdId: householdId,
            invitedEmail: invitedEmail.lowercased(),
            invitedByUserId: invitedByUserId,
            status: .pending,
            createdAt: Date()
        )

        try db.collection("householdInvites")
            .addDocument(from: invite)
    }

    func acceptInvite(
        inviteId: String,
        householdId: String,
        userId: String
    ) async throws {
        try await db.collection("households")
            .document(householdId)
            .updateData([
                "memberIds": FieldValue.arrayUnion([userId])
            ])

        try await db.collection("users")
            .document(userId)
            .updateData([
                "householdId": householdId
            ])

        try await db.collection("householdInvites")
            .document(inviteId)
            .updateData([
                "status": InviteStatus.accepted.rawValue
            ])
    }

    func removeMember(
        householdId: String,
        userId: String
    ) async throws {
        try await db.collection("households")
            .document(householdId)
            .updateData([
                "memberIds": FieldValue.arrayRemove([userId])
            ])

        try await db.collection("users")
            .document(userId)
            .updateData([
                "householdId": FieldValue.delete()
            ])
    }
}
