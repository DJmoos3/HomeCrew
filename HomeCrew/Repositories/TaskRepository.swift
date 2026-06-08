//
//  TaskRepository.swift
//  HomeCrew
//
//  Created by Urwa Adil on 2026-06-04.
//

import FirebaseFirestore
import Foundation

final class TaskRepository {

    private lazy var db = Firestore.firestore()

    // MARK: - CREATE TASK
    func createTask(
        title: String,
        description: String = "",
        householdID: String,
        assignedToUserID: String?,
        createdByUserID: String,
        dueDate: Date
    ) async throws {

        let task = HouseholdTask(
            title: title,
            description: description,
            householdID: householdID,
            assignedToUserID: assignedToUserID,
            createdByUserID: createdByUserID,
            dueDate: dueDate,
            completed: false,
            createdAt: Date()
        )

        try db.collection("tasks")
            .addDocument(from: task)
    }

    // MARK: - FETCH TASKS (THIS IS THE ONE YOU WERE ASKING ABOUT)
    func fetchTasks(householdID: String) async throws -> [HouseholdTask] {

        let snapshot = try await db.collection("tasks")
            .whereField("householdID", isEqualTo: householdID)
            .getDocuments()

        return try snapshot.documents.map {
            try $0.data(as: HouseholdTask.self)
        }
    }

    // MARK: - TOGGLE TASK
    func toggleTaskCompletion(taskID: String, completed: Bool) async throws {

        try await db.collection("tasks")
            .document(taskID)
            .updateData([
                "completed": completed
            ])
    }

    // MARK: - ASSIGN TASK
    func assignTask(taskID: String, assignedToUserID: String?) async throws {

        try await db.collection("tasks")
            .document(taskID)
            .updateData([
                "assignedToUserID": assignedToUserID as Any
            ])
    }

    // MARK: - DELETE TASK
    func deleteTask(taskID: String) async throws {

        try await db.collection("tasks")
            .document(taskID)
            .delete()
    }
}
