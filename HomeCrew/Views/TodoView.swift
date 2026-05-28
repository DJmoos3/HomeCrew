//
//  TodoView.swift
//  HomeCrew
//
//  Created by Erik on 2026-05-20.
//

import SwiftUI

struct TodoView: View {
    
    @State private var showingSheet: Bool = false
    
    @State private var selectedTab: TaskTab = .myTasks
    
    enum TaskTab {
        case myTasks
        case householdTasks
    }
    
    private let days = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    
    private var currentWeek: [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())!.start
        
        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: startOfWeek)
        }
    }
    
    var body: some View {
        VStack {
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
                    Text("Hello, User")
                        .font(.largeTitle.bold())
                        .foregroundStyle(HomeCrewTheme.textPrimary)
                    Text("You have **4 tasks** left today")
                        .font(.subheadline)
                        .foregroundStyle(HomeCrewTheme.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "bubble.right")
                    .font(.system(size: 25))
                    .foregroundStyle(HomeCrewTheme.primaryPurple)
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
                                .foregroundStyle(selectedTab == .myTasks ? HomeCrewTheme.darkBlue : HomeCrewTheme.cardBackground)
                        )
                        .foregroundStyle(selectedTab == .myTasks ? .white : HomeCrewTheme.textPrimary)
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
                                .foregroundStyle(selectedTab == .householdTasks ? HomeCrewTheme.darkBlue : HomeCrewTheme.cardBackground)
                        )
                        .foregroundStyle(selectedTab == .householdTasks ? .white : HomeCrewTheme.textPrimary)
                }
            }
            .padding(.bottom)
            
            HStack {
                ForEach(days.indices, id: \.self) { index in
                    VStack {
                        Text(days[index])
                            .font(.subheadline.bold())
                        Text(currentWeek[index].formatted(.dateTime.day()))
                            .font(.title3.bold())
                        Text("2/2")
                            .font(.footnote)
                    }
                    .padding(4)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Calendar.current.isDateInToday(currentWeek[index]) ? HomeCrewTheme.primaryPurple : HomeCrewTheme.cardBackground))
                    .foregroundStyle(Calendar.current.isDateInToday(currentWeek[index]) ? .white : HomeCrewTheme.textPrimary)
                    .shadow(
                        color: Calendar.current.isDateInToday(currentWeek[index]) ? HomeCrewTheme.primaryPurple.opacity(0.25) : .clear, radius: 6, x: 0, y: 4
                    )
                }
            }
            .padding(.bottom)
            
            Group {
                switch selectedTab {
                    
                case .myTasks:
                    MyTasksView()
                    
                case .householdTasks:
                    HouseholdTasksView()
                }
            }
            
            Spacer()
        } //Main VStack end
        .padding()
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
                            .shadow(color: HomeCrewTheme.darkBlue.opacity(0.25), radius: 10, x: 0, y: 6)
                    }
                    .padding()
                    .sheet(isPresented: $showingSheet) {
                        AddTodoView()
                    }
                }
        .background(HomeCrewTheme.background)
    }
}

#Preview {
    TodoView()
}
