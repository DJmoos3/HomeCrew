//
//  HouseholdTasksView.swift
//  HomeCrew
//
//  Created by William Albinsson on 2026-05-21.
//

import SwiftUI

struct HouseholdTasksView: View {
    @Bindable var viewModel = TaskViewModel()
    let householdId: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Today's Tasks")
                .font(.headline)
            
            if viewModel.isLoading {
                ProgressView()
            }
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.tasks) { task in
                        HStack {
                            Image(systemName: task.completed ?  "checkmark.circle.fill" : "circle")
                                .font(.system(size: 34))
                                .foregroundStyle(.black.opacity(0.4))
                            
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
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(HomeCrewTheme.primaryPurple.opacity(0.08))
                        )
                        .onTapGesture {
                            Task {
                                await viewModel.toggleTask(task)
                            }
                            
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.fetchTasks(householdID: householdId)
        }
    }
}

#Preview {
    HouseholdTasksView(householdId: "preview-household")
}
