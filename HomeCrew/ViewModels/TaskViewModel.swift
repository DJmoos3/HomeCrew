//
//  TaskViewModel.swift
//  HomeCrew
//
//  Created by Urwa Adil on 2026-06-04.
//

import Foundation
import Observation

@Observable
final class TaskViewModel {

    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    var members: [Member] = []
    var selectedMemberID: String?

    var tasks: [HouseholdTask] = []

    private let repository: TaskRepository
    private let authRepository: AuthRepository
    private let householdRepository: HouseholdRepository
    
    init(
        repository: TaskRepository = TaskRepository(),
        authRepository: AuthRepository = .shared,
        householdRepository: HouseholdRepository = HouseholdRepository()
    ) {
        self.repository = repository
        self.authRepository = authRepository
        self.householdRepository = householdRepository
    }
    
    
    var currentUserId: String? {
        try? authRepository.getUser().uid
    }

    //Fetch member
    func fetchMembers(householdID: String) async {
        do {
            let household = try await householdRepository.fetchHousehold(
                householdId: householdID
            )

            members = try await householdRepository.fetchMembers(
                memberIds: household.memberIds
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    //Load tasks
    func fetchTasks(householdID: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            tasks = try await repository.fetchTasks(householdID: householdID)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    //Create task
    func createTask(
        title: String,
        description: String = "",
        householdID: String,
        assignedToUserID: String?,
        dueDate: Date
        
    ) async {
        print("Createtask called")


        isLoading = true
        defer { isLoading = false }

        do {
            let user = try authRepository.getUser()
            print("got user", user.uid)


            let taskID = try await repository.createTask(
                title: title,
                description: description,
                householdID: householdID,
                assignedToUserID: assignedToUserID,
                createdByUserID: user.uid,
                dueDate: dueDate
            )
            print("🔥 Firestore write success")

            NotificationManager.shared.scheduleTaskReminder(
                taskID: taskID,
                title: title,
                dueDate: dueDate
            )
            await fetchTasks(householdID: householdID)

        } catch {
            print("🔥 Firestore write failed", error)
            errorMessage = error.localizedDescription
        }
    }

    //Toggle completion
    func toggleTask(_ task: HouseholdTask) async {
        guard let id = task.id else { return }

        do {
            try await repository.toggleTaskCompletion(
                taskID: id,
                completed: !task.completed
            )

            if let index = tasks.firstIndex(where: { $0.id == id }) {
                tasks[index].completed.toggle()
            }

            if !task.completed {
                NotificationManager.shared.cancelTaskReminder(taskID: id)
            }

        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    //Assign Task
    func assignTask(taskID: String,assignedToUserID: String?, householdID: String) async {
        do {
            try await repository.assignTask(
                taskID: taskID,assignedToUserID: assignedToUserID)
            
            await fetchTasks(householdID: householdID)


        } catch {
            errorMessage = error.localizedDescription
        }
    }

    //Delete task
    func deleteTask(taskID: String, householdID: String) async {
        NotificationManager.shared.cancelTaskReminder(taskID: taskID)
        do {
            try await repository.deleteTask(taskID: taskID)
            await fetchTasks(householdID: householdID)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
