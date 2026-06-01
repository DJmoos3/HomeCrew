//
//  HouseholdRepository.swift
//  HomeCrew
//
//  Created by Isaac Strandh on 2026-05-28.
//

//import Foundation
//import FirebaseFirestore
//
//final class HouseholdRepository {
//    private lazy var db = Firestore.firestore()
//    
//    func createHousehold(name: String, authUser: AuthDataResultModel) async throws {
//        let household = Household(name: name, memberIds: [authUser.uid], createdBy: authUser.uid)
//        let ref = try db.collection("households").addDocument(from: household)
//        try await db.collection("users").document(authUser.uid).updateData(["householdId": ref.documentID])
//    }
//}
import Foundation
import FirebaseFirestore

final class HouseholdRepository {

    private let db = Firestore.firestore()

    func createHousehold(name: String, userId: String) async throws {

        let household = Household(
            name: name,
            memberIds: [userId],
            createdBy: userId
        )

        let ref = try db.collection("households")
            .addDocument(from: household)

        try await db.collection("users")
            .document(userId)
            .updateData([
                "householdId": ref.documentID
            ])
    }
}
