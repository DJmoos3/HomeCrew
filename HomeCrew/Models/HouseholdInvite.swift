//
//  HouseholdInvite.swift
//  HomeCrew
//
//  Created by Erik on 2026-06-03.
//

import Foundation
import FirebaseFirestore

struct HouseholdInvite: Codable, Identifiable {
    @DocumentID var id: String?
    var householdId: String
    var invitedEmail: String
    var invitedByUserId: String
    var status: InviteStatus
    var createdAt: Date
}

enum InviteStatus: String, Codable {
    case pending
    case accepted
    case declined
}
