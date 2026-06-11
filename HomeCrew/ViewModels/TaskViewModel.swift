//
//  TaskViewModel.swift
//  HomeCrew
//
//  Created by Urwa Adil on 2026-06-04.
//

import Foundation
import Observation
internal import FirebaseFirestoreInternal

enum TaskRecurrence: String, Codable{
    case once
    case daily
    case weekly
    case everyOtherWeek
    case monthly
    
    var displayName: String {
            switch self {
            case .once:
                return "Once"
            case .daily:
                return "Daily"
            case .weekly:
                return "Weekly"
            case .everyOtherWeek:
                return "Every Other Week"
            case .monthly:
                return "Monthly"
            }
        }
    
}

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
        dueDate: Date,
        recurrence: TaskRecurrence = .once
        
    ) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let user = try authRepository.getUser()
            print("got user", user.uid)
            
            try await repository.createTask(
                title: title,
                description: description,
                householdID: householdID,
                assignedToUserID: assignedToUserID,
                createdByUserID: user.uid,
                dueDate: dueDate,
                recurrence: recurrence
            )
            await fetchTasks(householdID: householdID)

        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func isTaskActive(_ task: HouseholdTask) -> Bool {
        let calendar = Calendar.current

        switch task.recurrence {

        case .once:
            return task.lastCompleted == nil

        case .daily:
            return !calendar.isDateInToday(
                task.lastCompleted ?? .distantPast)

        case .weekly:
            return !calendar.isDate(
                task.lastCompleted ?? .distantPast,
                equalTo: Date(),
                toGranularity: .weekOfYear)

        case .everyOtherWeek:
            let weeks = calendar.dateComponents(
                [.weekOfYear],
                from: task.lastCompleted ?? .distantPast,
                to: Date()
                ).weekOfYear ?? 0
                return weeks >= 2

        case .monthly:
            return !calendar.isDate(
                task.lastCompleted ?? .distantPast,
                equalTo: Date(),
                toGranularity: .month)
        }
    }
    
    func toggleTask(_ task: HouseholdTask) async {
        guard let id = task.id else { return }
        guard isTaskActive(task) else { return }

        do {
            let now = Date()
            
            let newDate = nextDueDate(from: task.dueDate, recurrence: task.recurrence)

            try await repository.db
                .collection("tasks")
                .document(id)
                .updateData([
                    "dueDate": newDate,
                    "lastCompleted": now
                ])

            if let index = tasks.firstIndex(where: { $0.id == id }) {
                tasks[index].dueDate = newDate
                tasks[index].lastCompleted = now
            }

        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func nextDueDate(from date: Date, recurrence: TaskRecurrence) -> Date {
        let calendar = Calendar.current

        switch recurrence {
        case .once:
            return date

        case .daily:
            return calendar.date(byAdding: .day, value: 1, to: date)!

        case .weekly:
            return calendar.date(byAdding: .weekOfYear, value: 1, to: date)!

        case .everyOtherWeek:
            return calendar.date(byAdding: .weekOfYear, value: 2, to: date)!

        case .monthly:
            return calendar.date(byAdding: .month, value: 1, to: date)!
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
        do {
            try await repository.deleteTask(taskID: taskID)
            await fetchTasks(householdID: householdID)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
