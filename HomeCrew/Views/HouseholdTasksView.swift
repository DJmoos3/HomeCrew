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
            Text("Household Tasks")
                .font(.headline)
            
            if viewModel.isLoading {
                ProgressView()
            }
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.tasks.sorted{
    
                        return $0.dueDate > $1.dueDate
                    }
                    ) { task in
                        HStack {
                            Image(systemName: viewModel.isTaskActive(task) ?  "circle": "checkmark.circle.fill")
                                .font(.system(size: 34))
                                .foregroundStyle(.black.opacity(0.4))
                            
                            //Assigned user Avatar
                            if let userId = task.assignedToUserID {
                                   Circle()
                                       .fill(avatarColor(for: userId))
                                       .frame(width: 28, height: 28)
                                       .overlay {
                                           Text(initials(for: userId))
                                               .font(.caption2)
                                               .fontWeight(.bold)
                                               .foregroundStyle(.white)
                                       }
                               }
                          
                            
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
    //Adding function for avatar for each member
    private func member(for userId: String)-> Member? {
        viewModel.members.first{ $0.id == userId }
    }
    //Function for initial letter
    private func initials(for userId: String) -> String {
        let name = member(for: userId)?.name ?? "?"
        let parts = name.split(separator: " ")
        
        let initials = parts.prefix(2)
            .compactMap{ $0.first }
            .map{ String($0).uppercased() }
            .joined()
        return initials.isEmpty ? "?" : initials
    }
    private func avatarColor(for userId: String)-> Color {
        let colors: [Color] = [.purple, .blue, .green, .orange, .pink, .teal, .indigo]
        return colors[abs(userId.hashValue) % colors.count]
        
    }
}

#Preview {
    HouseholdTasksView(householdId: "preview-household")
}
