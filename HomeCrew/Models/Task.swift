//
//  Task.swift
//  HomeCrew
//
//  Created by Urwa Adil on 2026-06-04.
//

import Foundation
import FirebaseFirestore

struct HouseholdTask: Codable, Identifiable {
    @DocumentID var id: String?
    
    var title: String
    var description: String
    
    var householdID: String
    var assignedToUserID: String?
    var createdByUserID: String
    
    var dueDate: Date
    
    var completed: Bool = false
    var createdAt: Date = Date()
    var recurrence: TaskRecurrence = .once
}
