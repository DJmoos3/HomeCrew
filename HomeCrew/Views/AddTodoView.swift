//
//  AddTodoView.swift
//  HomeCrew
//
//  Created by William Albinsson on 2026-05-21.
//

import SwiftUI

struct AddTodoView: View {
    
    @State private var taskTitle: String = ""
    @State private var selectedCategory: String = "Kitchen"
    @State private var selectedDay: Int = 0
    @State private var selectedTime = Date()
    @State private var timeDuration: Int = 0
    @State private var selectedRepeat = "Once"
    
    private let categories = ["Kitchen", "Bathroom", "Laundry", "Clean"]
    private let categoryIcons = ["fork.knife", "bathtub", "dryer", "paintbrush"]
    private let days = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    private let repeatChoice = ["Once", "Daily", "Weekly", "Every Other Week", "Monthly"]
    
    private var currentWeek: [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())!.start
        
        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: startOfWeek)
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            TextField("Add a new task", text: $taskTitle)
                .padding()
                .background(HomeCrewTheme.cardBackground)
                .cornerRadius(12)
                .foregroundStyle(HomeCrewTheme.textPrimary)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Category")
                    .font(.headline)
                    .foregroundStyle(HomeCrewTheme.textPrimary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(categories.indices, id: \.self) { index in
                            HStack(spacing: 6) {
                                Image(systemName: categoryIcons[index])
                                Text(categories[index])
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(
                                        selectedCategory == categories[index]
                                        ? HomeCrewTheme.darkBlue
                                        : HomeCrewTheme.cardBackground
                                    )
                            )
                            .foregroundStyle(
                                selectedCategory == categories[index]
                                ? .white
                                : HomeCrewTheme.textPrimary
                            )
                            .onTapGesture {
                                selectedCategory = categories[index]
                            }
                        }
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Day")
                    .font(.headline)
                    .foregroundStyle(HomeCrewTheme.textPrimary)
                
                HStack {
                    ForEach(days.indices, id: \.self) { index in
                        VStack {
                            Text(days[index])
                                .font(.subheadline.bold())
                            
                            Text(currentWeek[index].formatted(.dateTime.day()))
                                .font(.title3.bold())
                        }
                        .padding(5)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(
                                    selectedDay == index
                                    ? HomeCrewTheme.primaryPurple
                                    : HomeCrewTheme.cardBackground
                                )
                        )
                        .foregroundStyle(
                            selectedDay == index
                            ? .white
                            : HomeCrewTheme.textPrimary
                        )
                        .onTapGesture {
                            selectedDay = index
                        }
                    }
                }
            }
            
            HStack(spacing: 16) {
                
                VStack(alignment: .leading) {
                    Text("Time")
                        .font(.headline)
                        .foregroundStyle(HomeCrewTheme.textPrimary)
                    
                    HStack {
                        Image(systemName: "clock")
                            .foregroundStyle(HomeCrewTheme.textSecondary)
                        
                        DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .tint(HomeCrewTheme.primaryPurple)
                    }
                    .padding()
                    .background(HomeCrewTheme.cardBackground)
                    .cornerRadius(12)
                }
                
                VStack(alignment: .leading) {
                    Text("Duration")
                        .font(.headline)
                        .foregroundStyle(HomeCrewTheme.textPrimary)
                    
                    HStack(spacing: 10) {
                        Button {
                            timeDuration = max(0, timeDuration - 5)
                        } label: {
                            Image(systemName: "minus")
                                .foregroundStyle(.white)
                                .frame(width: 32, height: 32)
                                .background(HomeCrewTheme.darkBlue)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .disabled(timeDuration == 0)
                        
                        Text("\(timeDuration) min")
                            .foregroundStyle(HomeCrewTheme.textPrimary)
                        
                        Button {
                            timeDuration += 5
                        } label: {
                            Image(systemName: "plus")
                                .foregroundStyle(.white)
                                .frame(width: 32, height: 32)
                                .background(HomeCrewTheme.darkBlue)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding()
                    .background(HomeCrewTheme.cardBackground)
                    .cornerRadius(12)
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Repeat")
                    .font(.headline)
                    .foregroundStyle(HomeCrewTheme.textPrimary)
                
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 120), spacing: 8)],
                    spacing: 8
                ) {
                    ForEach(repeatChoice, id: \.self) { option in
                        
                        Text(option)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(
                                        selectedRepeat == option
                                        ? HomeCrewTheme.darkBlue
                                        : HomeCrewTheme.cardBackground
                                    )
                            )
                            .foregroundStyle(
                                selectedRepeat == option
                                ? .white
                                : HomeCrewTheme.textPrimary
                            )
                            .onTapGesture {
                                selectedRepeat = option
                            }
                    }
                }
            }
            
            Spacer()
            
            Button {
                // Add task action
            } label: {
                Text("Add Task")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(HomeCrewTheme.darkBlue)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                    .shadow(color: HomeCrewTheme.darkBlue.opacity(0.2), radius: 8, x: 0, y: 4)
            }
        }
        .padding()
        .background(HomeCrewTheme.background)
    }
}

#Preview {
    AddTodoView()
}
