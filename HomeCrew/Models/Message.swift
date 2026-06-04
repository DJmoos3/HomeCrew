//
//  Message.swift
//  HomeCrew
//
//  Created by Erik on 2026-06-04.
//

import Foundation
import FirebaseFirestore

struct Message: Codable, Identifiable {
    @DocumentID var id: String?
    var text: String
    var senderId: String
    var createdAt: Date
}
