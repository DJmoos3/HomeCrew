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
    @discardableResult
    func createTask(
        title: String,
        description: String = "",
        householdID: String,
        assignedToUserID: String?,
        createdByUserID: String,
        dueDate: Date,
        recurrence: TaskRecurrence = .once
    ) async throws -> String {

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

        let docRef = try db
            .collection("households")
            .document(householdID)
            .collection("tasks")
            .addDocument(from: task)
        return docRef.documentID
    }

    //FETCH TASKS
    func fetchTasks(householdID: String) async throws -> [HouseholdTask] {

        let snapshot = try await db.collection("households")
            .document(householdID).collection("tasks")
            .whereField("householdID", isEqualTo: householdID)
            .getDocuments()

        return snapshot.documents.compactMap {doc in
            try? doc.data(as: HouseholdTask.self)
        }
    }

////    //TOGGLE TASK
//    func toggleTaskCompletion(taskID: String, completed: Bool) async throws {
//
//        try await db.collection("households")
//        .document(householdID).collection("tasks")
//            .document(taskID)
//            .updateData([
//                "completed": completed
//            ])
//    }

    func completeTask(householdID: String, taskID: String, dueDate: Date, lastCompleted: Date) async throws {
        try await db.collection("households")
            .document(householdID).collection("tasks")
            .document(taskID)
            .updateData([
                "dueDate": dueDate,
                "lastCompleted": lastCompleted
            ])
    }
    
    //ASSIGN TASK
    func assignTask(householdID: String, taskID: String, assignedToUserID: String?) async throws {

        try await db.collection("households")
            .document(householdID).collection("tasks")
            .document(taskID)
            .updateData([
                "assignedToUserID": assignedToUserID as Any
            ])
    }

    //DELETE TASK
    func deleteTask(householdID: String, taskID: String) async throws {

        try await db.collection("households")
            .document(householdID).collection("tasks")
            .document(taskID)
            .delete()
    }
}
