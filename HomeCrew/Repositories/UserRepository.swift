//
//  UserRepository.swift
//  HomeCrew
//
//  Created by Erik on 2026-05-26.
//

import Foundation
import FirebaseFirestore

final class UserRepository {
    private lazy var db = Firestore.firestore()
    
    func createUser(authUser: AuthDataResultModel, username: String) async throws {
        
        let appUser = AppUser(id: authUser.uid, username: username, email: authUser.email!)
        try db.collection("users").document(authUser.uid).setData(from: appUser)
        
    }
    // Update username in Firestore (omar)
    
    func updateUsername(uid: String, username: String) async throws {

            try await db.collection("users").document(uid).updateData([

                "username": username

            ])

        }
}
