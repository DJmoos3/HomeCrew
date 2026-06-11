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

    //CREATE TASK
    func createTask(
        title: String,
        description: String = "",
        householdID: String,
        assignedToUserID: String?,
        createdByUserID: String,
        dueDate: Date,
        recurrence: TaskRecurrence = .once
    ) async throws {

        let task = HouseholdTask(
            title: title,
            description: description,
            householdID: householdID,
            assignedToUserID: assignedToUserID,
            createdByUserID: createdByUserID,
            dueDate: dueDate,
            createdAt: Date(),
            recurrence: recurrence
        )

        try db.collection("tasks")
            .addDocument(from: task)
    }

    //FETCH TASKS
    func fetchTasks(householdID: String) async throws -> [HouseholdTask] {

        let snapshot = try await db.collection("tasks")
            .whereField("householdID", isEqualTo: householdID)
            .getDocuments()

        return snapshot.documents.compactMap {doc in
            try? doc.data(as: HouseholdTask.self)
        }
    }

////    //TOGGLE TASK
//    func toggleTaskCompletion(taskID: String, completed: Bool) async throws {
//
//        try await db.collection("tasks")
//            .document(taskID)
//            .updateData([
//                "completed": completed
//            ])
//    }

    func completeTask(taskID: String, dueDate: Date, lastCompleted: Date) async throws {
        try await db.collection("tasks")
            .document(taskID)
            .updateData([
                "dueDate": dueDate,
                "lastCompleted": lastCompleted
            ])
    }
    
    //ASSIGN TASK
    func assignTask(taskID: String, assignedToUserID: String?) async throws {

        try await db.collection("tasks")
            .document(taskID)
            .updateData([
                "assignedToUserID": assignedToUserID as Any
            ])
    }

    //DELETE TASK
    func deleteTask(taskID: String) async throws {

        try await db.collection("tasks")
            .document(taskID)
            .delete()
    }
}
