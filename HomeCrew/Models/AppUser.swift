//
//  AppUser.swift
//  HomeCrew
//
//  Created by Erik on 2026-05-26.
//

import Foundation
import FirebaseFirestore

struct AppUser: Codable, Identifiable {
    @DocumentID var id: String?
    var username: String
    var email: String
    var householdId: String?
}
