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
        return viewModel.tasks.filter { $0.assignedToUserID == currentUserId }
    }

    private var nextTask: HouseholdTask? {
        myTask.first(where: { !$0.completed })
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

                    Image(systemName: "fork.knife")
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

            // TASK LIST
            VStack(alignment: .leading) {
                Text("Today's Tasks")

                List {
                    ForEach(myTask) { task in
                        HStack {

                            Image(systemName: task.completed
                                  ? "checkmark.circle.fill"
                                  : "circle")
                                .font(.system(size: 34))
                                .foregroundStyle(HomeCrewTheme.primaryPurple)

                            VStack(alignment: .leading) {
                                Text(task.title)

                                HStack {
                                    Image(systemName: "clock")
                                    Text(task.dueDate.formatted(date: .abbreviated, time: .shortened))
                                }
                                .font(.caption)
                            }

                            Spacer()

                            Image(systemName: "fork.knife")
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
