//
//  Chat.swift
//  HomeCrew
//
//  Created by Erik on 2026-06-04.
//

import Foundation
import FirebaseFirestore

enum ChatType: String, Codable {
    case group
    case direct
}

struct Chat: Codable, Identifiable {
    @DocumentID var id: String?
    var type: ChatType
    var title: String
    var memberIds: [String]
    var createdAt: Date
    var lastMessage: String?
    var lastMessageAt: Date?
}
