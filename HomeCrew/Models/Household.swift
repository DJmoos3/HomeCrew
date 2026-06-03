//
//  Household.swift
//  HomeCrew
//
//  Created by Isaac Strandh on 2026-05-28.

import Foundation
import FirebaseFirestore

struct Household: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var memberIds: [String]
    var createdBy: String
}
