//
//  Household.swift
//  HomeCrew
//
//  Created by Urwa Adil on 2026-06-01.
//

import Foundation
import FirebaseFirestore
import SwiftUI

struct Household: Codable, Identifiable {
    
    @DocumentID var id: String?

    var name: String
    var memberIds: [String]
    var createdBy: String
}
