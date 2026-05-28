//
//  MyTasksView.swift
//  HomeCrew
//
//  Created by William Albinsson on 2026-05-21.
//

import SwiftUI

struct MyTasksView: View {
    var body: some View {
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
                        Text("Task 1")
                            .foregroundStyle(.white)
                        HStack {
                            Image(systemName: "clock")
                            Text("06:00 PM · 20 min")
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

        VStack(alignment: .leading) {
            Text("Today's Tasks")
                .font(.headline)
            VStack(alignment: .leading) {
                List {
                    ForEach(0..<5, id: \.self) { index in
                        HStack {
                            Image(systemName: "circle")
                                .font(.system(size: 34))
                                .foregroundStyle(HomeCrewTheme.primaryPurple)

                            VStack(alignment: .leading) {
                                Text("Task 1")
                                HStack {
                                    Image(systemName: "clock")
                                    Text("06:00 PM · 20 min")
                                }
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
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .frame(maxHeight: 300)  // important so it behaves like a block
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(HomeCrewTheme.darkBlue.opacity(0.04))
            )
        }

    }
}

#Preview {
    MyTasksView()
}
