//
//  MyTasksView.swift
//  HomeCrew
//
//  Created by William Albinsson on 2026-05-21.
//

import SwiftUI

struct MyTasksView: View {

    @Bindable var viewModel = TaskViewModel()
    let householdID: String

    private var myTask: [HouseholdTask] {
        guard let currentUserId = viewModel.currentUserId else { return [] }
        
        return viewModel.tasks
            .filter { $0.assignedToUserID == currentUserId }
            .sorted {
                return $0.dueDate > $1.dueDate
                    }
    }

    private var nextTask: HouseholdTask? {
        myTask.first(where: { viewModel.isTaskActive($0) })
    }

    var body: some View {
        VStack {

            //NEXT TASK
            if let nextTask {
                HStack {
                    VStack(alignment: .leading) {

                        Text("NEXT TASK")
                            .font(.headline)
                            .foregroundStyle(.white)

                        HStack {
                            Image(systemName: "circle")
                                .font(.system(size: 34))
                                .foregroundStyle(HomeCrewTheme.mintGreen)

                            VStack(alignment: .leading) {
                                Text(nextTask.title)
                                    .foregroundStyle(.white)

                                HStack {
                                    Image(systemName: "clock")
                                    Text(nextTask.dueDate.formatted(date: .abbreviated, time: .shortened))
                                }
                                .foregroundStyle(.white)
                            }

                            Spacer()
                        }
                    }

                    Image(systemName: "square.stack.3d.up")
                        .padding()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(HomeCrewTheme.darkBlue)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(HomeCrewTheme.mintGreen)
                        )
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(HomeCrewTheme.darkBlue)
                )
                .padding(.bottom)
            }

            //Task list
            VStack(alignment: .leading) {
                Text("My Tasks")

                List {
                    ForEach(myTask) { task in
                        HStack {

                            Image(systemName: viewModel.isTaskActive(task) ? "circle": "checkmark.circle.fill"
                                  )
                                .font(.system(size: 34))
                                .foregroundStyle(HomeCrewTheme.primaryPurple)

                            VStack(alignment: .leading) {
                                Text(task.title)

                                HStack {
                                    Text(task.recurrence.displayName)
                                    if task.recurrence != .once {
                                        Image(systemName: "repeat")
                                    }
                                    
                                }
                                .font(.caption)
                            }

                            Spacer()

                            Image(systemName: "square.stack.3d.up")
                                .padding()
                                .frame(width: 40, height: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(HomeCrewTheme.primaryPurple)
                                )
                                .foregroundStyle(.white)
                        }
                        .padding(.vertical, 8)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .onTapGesture {
                            Task {
                                await viewModel.toggleTask(task)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        Task {
                            for index in indexSet {
                                let task = myTask[index]
                                
                                if let id = task.id {
                                    await viewModel.deleteTask(taskID: id, householdID: householdID)
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .frame(maxHeight: 300)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(HomeCrewTheme.darkBlue.opacity(0.04))
            )
        }
        .task {
            await viewModel.fetchTasks(householdID: householdID)
        }
    }
}

#Preview {
    MyTasksView(householdID: "preview-household")
}
