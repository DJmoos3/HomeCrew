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
        VStack {
            TextField("Add a new task", text: $taskTitle)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text("Category")
                    .font(.headline)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(categories.indices, id: \.self) { index in
                            HStack {
                                Image(systemName: categoryIcons[index])
                                Text(categories[index])
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: 28)
                            .background(RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(selectedCategory == categories[index] ? .black : Color(.systemGray3)))
                            .foregroundStyle(selectedCategory == categories[index] ? .white : .black)
                            .onTapGesture {
                                selectedCategory = categories[index]
                            }
                        }
                    }
                }
            }
            
            VStack(alignment: .leading) {
                Text("Day")
                    .font(.headline)
                
                HStack {
                    ForEach(days.indices, id: \.self) { index in
                        VStack {
                            Text(days[index])
                                .font(.subheadline.bold())
                            Text(currentWeek[index].formatted(.dateTime.day()))
                                .font(.title3.bold())
                        }
                        .padding(4)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(selectedDay == index ? .black : Color(.systemGray3)))
                        .foregroundStyle(selectedDay == index ? .white : .black)
                        .onTapGesture {
                            selectedDay = index
                        }
                    }
                }
                .padding(.bottom)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Time")
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: "clock")
                        DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color(.systemGray3)))
                    .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Time Duration")
                        .font(.headline)
                    
                    HStack {
                        Button {
                            timeDuration = max(0, timeDuration - 5)
                        } label: {
                            Image(systemName: "minus")
                                .padding()
                                .frame(width: 35, height: 35)
                                .background(RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.gray))
                                .foregroundStyle(.black)
                        }
                        .disabled(timeDuration == 0)
                        
                        Text("\(timeDuration) min")
                        
                        Button {
                            timeDuration += 5
                        } label: {
                            Image(systemName: "plus")
                                .padding()
                                .frame(width: 35, height: 35)
                                .background(RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.gray))
                                .foregroundStyle(.black)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color(.systemGray3)))
                }
            }
            
            
            VStack(alignment: .leading) {
                Text("Repeat")
                    .font(.headline)
                
                LazyVGrid(
                    columns: [
                        GridItem(.adaptive(minimum: 120), spacing: 8)
                    ],
                    spacing: 8
                ) {
                    ForEach(repeatChoice, id: \.self) { index in
                        
                        Text(index)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(selectedRepeat == index ? .black : Color(.systemGray3))
                            )
                            .foregroundStyle(selectedRepeat == index ? .white : .black)
                            .onTapGesture {
                                selectedRepeat = index
                            }
                    }
                }
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Text("Add Task")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray3))
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
            
        }
        .padding()
    }
}

#Preview {
    AddTodoView()
}
