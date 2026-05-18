//
//  HomeView.swift
//  HomeCrew
//
//  Created by Omar Qasoma on 2026-05-18.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("HomeCrew")
                .font(.largeTitle)
                .bold()

            Text("Share the chores. Enjoy the home.")
                .foregroundStyle(.secondary)

            Text("Today's Tasks")
                .font(.title2)
                .bold()
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
