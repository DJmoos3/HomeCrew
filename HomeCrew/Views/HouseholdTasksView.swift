//
//  HouseholdTasksView.swift
//  HomeCrew
//
//  Created by William Albinsson on 2026-05-21.
//

import SwiftUI

struct HouseholdTasksView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Today's Tasks")
                .font(.headline)

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(0...5, id: \.self) { index in
                        HStack {
                            Image(systemName: "circle")
                                .font(.system(size: 34))
                                .foregroundStyle(.black.opacity(0.4))
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
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(HomeCrewTheme.primaryPurple.opacity(0.08))
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    HouseholdTasksView()
}
