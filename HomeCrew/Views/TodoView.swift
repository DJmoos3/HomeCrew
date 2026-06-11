//
//  TodoView.swift
//  HomeCrew
//
//  Created by Erik on 2026-05-20.
//

import SwiftUI

struct TodoView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(ChatNotificationViewModel.self) private var chatNotificationViewModel

    @State private var showingSheet: Bool = false
    @State private var selectedTab: TaskTab = .myTasks
    @State private var taskViewModel = TaskViewModel()

    @State private var showSuccess: Bool = false
    @State private var selectedDate: Date = Date()

    enum TaskTab {
        case myTasks
        case householdTasks
    }

    private let days = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]

    private var tasksLeftCount: Int {
        guard let currentUserId = taskViewModel.currentUserId else { return 0 }

        return taskViewModel.tasks.filter {
            taskViewModel.isTaskActive($0) &&
            $0.assignedToUserID == currentUserId
        }.count
    }

    private var currentWeek: [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())!.start

        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: startOfWeek)
        }
    }

    // Show completed/total tasks for each day
    private func taskCount(for date: Date) -> String {
        let calendar = Calendar.current

        let tasksForDay = taskViewModel.tasks.filter {
            calendar.isDate($0.dueDate, inSameDayAs: date)
        }

        let completed = tasksForDay.filter {
            !taskViewModel.isTaskActive($0)
        }.count

        return "\(completed)/\(tasksForDay.count)"
    }

    // Tasks for selected day
    private var selectedDayTasks: [HouseholdTask] {
        let calendar = Calendar.current

        return taskViewModel.tasks.filter {
            calendar.isDate($0.dueDate, inSameDayAs: selectedDate)
        }
    }

    var body: some View {
        VStack {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text(
                        Date().formatted(
                            .dateTime
                                .weekday(.wide)
                                .day()
                                .month(.wide)
                        )
                    )
                    .font(.callout)
                    .foregroundStyle(HomeCrewTheme.textSecondary)

                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hello, \(authViewModel.currentUser?.username ?? "User")")
                                .font(.largeTitle.bold())
                                .foregroundStyle(HomeCrewTheme.textPrimary)

                            Text("You have **\(tasksLeftCount) \(tasksLeftCount == 1 ? "task" : "tasks")** left.")
                                .font(.subheadline)
                                .foregroundStyle(HomeCrewTheme.textSecondary)
                        }

                        Spacer()
                    }
                }

                Spacer()

                HStack(spacing: 16) {
                    NavigationLink {
                        ChatListView()
                            .environment(authViewModel)
                            .environment(chatNotificationViewModel)
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bubble.right")
                                .font(.system(size: 25))
                                .foregroundStyle(HomeCrewTheme.primaryPurple)

                            if chatNotificationViewModel.hasUnreadMessages {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 9, height: 9)
                                    .offset(x: 4, y: -4)
                            }
                        }
                    }

                    NavigationLink {
                        ProfileView()
                            .environment(authViewModel)
                    } label: {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(HomeCrewTheme.primaryPurple)
                            .contentShape(Circle())
                    }
                }
            }
            .padding(.bottom)

            HStack {
                Button {
                    selectedTab = .myTasks
                } label: {
                    Text("My Tasks")
                        .padding()
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(
                                    selectedTab == .myTasks
                                    ? HomeCrewTheme.darkBlue
                                    : HomeCrewTheme.cardBackground
                                )
                        )
                        .foregroundStyle(
                            selectedTab == .myTasks
                            ? .white
                            : HomeCrewTheme.textPrimary
                        )
                }

                Button {
                    selectedTab = .householdTasks
                } label: {
                    Text("Household Tasks")
                        .padding()
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(
                                    selectedTab == .householdTasks
                                    ? HomeCrewTheme.darkBlue
                                    : HomeCrewTheme.cardBackground
                                )
                        )
                        .foregroundStyle(
                            selectedTab == .householdTasks
                            ? .white
                            : HomeCrewTheme.textPrimary
                        )
                }
            }
            .padding(.bottom)

            HStack {
                ForEach(days.indices, id: \.self) { index in
                    let date = currentWeek[index]

                    VStack {
                        Text(days[index])
                            .font(.subheadline.bold())

                        Text(date.formatted(.dateTime.day()))
                            .font(.title3.bold())

                        Text(taskCount(for: date))
                            .font(.footnote)
                    }
                    .padding(4)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                Calendar.current.isDateInToday(date)
                                ? HomeCrewTheme.primaryPurple
                                : HomeCrewTheme.cardBackground
                            )
                    )
                    .foregroundStyle(
                        Calendar.current.isDate(date, inSameDayAs: selectedDate)
                        ? HomeCrewTheme.mintGreen
                        : HomeCrewTheme.textPrimary
                    )
                    .shadow(
                        color: Calendar.current.isDateInToday(date)
                        ? HomeCrewTheme.primaryPurple.opacity(0.25)
                        : .clear,
                        radius: 6,
                        x: 0,
                        y: 4
                    )
                    .onTapGesture {
                        selectedDate = date
                    }
                }
            }
            .padding(.bottom)

            VStack(alignment: .leading, spacing: 12) {
                Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.headline)

                if selectedDayTasks.isEmpty {
                    Text("No tasks for this day")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(selectedDayTasks) { task in
                        HStack {
                            Image(systemName: task.lastCompleted != nil ? "checkmark.circle.fill" : "circle")

                            Text(task.title)

                            Spacer()
                        }
                        .padding()
                        .background(HomeCrewTheme.cardBackground)
                        .cornerRadius(12)
                    }
                }
            }

            Group {
                switch selectedTab {
                case .myTasks:
                    if let householdId = authViewModel.currentUser?.householdId {
                        MyTasksView(
                            viewModel: taskViewModel,
                            householdID: householdId
                        )
                    } else {
                        Text("No household selected")
                    }

                case .householdTasks:
                    if let householdId = authViewModel.currentUser?.householdId {
                        HouseholdTasksView(
                            viewModel: taskViewModel,
                            householdId: householdId
                        )
                    } else {
                        Text("No household selected")
                    }
                }
            }

            Spacer()
        }
        .onAppear {
            Task {
                await authViewModel.fetchCurrentUser()

                if let householdId = authViewModel.currentUser?.householdId,
                   let currentUserId = authViewModel.currentUser?.id {
                    await taskViewModel.fetchTasks(householdID: householdId)
                    await taskViewModel.fetchMembers(householdID: householdId)

                    chatNotificationViewModel.startListening(
                        householdId: householdId,
                        currentUserId: currentUserId
                    )
                }
            }
        }
        .padding()
        .background(HomeCrewTheme.background)
        .overlay(alignment: .bottomTrailing) {
            Button {
                showingSheet = true
            } label: {
                Image(systemName: "plus")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .frame(width: 60, height: 60)
                    .background(HomeCrewTheme.darkBlue)
                    .clipShape(Circle())
                    .shadow(
                        color: HomeCrewTheme.darkBlue.opacity(0.25),
                        radius: 10,
                        x: 0,
                        y: 6
                    )
            }
            .padding()
        }
        .sheet(isPresented: $showingSheet) {
            if let user = authViewModel.currentUser,
               let householdId = user.householdId {
                AddTodoView(
                    householdID: householdId,
                    createdByUserID: user.id!,
                    onTaskCreated: {
                        showSuccess = true
                    }
                ).environment(taskViewModel)
            } else {
                Text("No user / household available")
            }
        }
        .alert("Task created", isPresented: $showSuccess) {
            Button("OK") { }
        } message: {
            Text("Your task is created successfully.")
        }
    }
}

#Preview {
    TodoView()
}

