//
//  ContentView.swift
//  HomeCrew
//
//  Created by Isaac Strandh on 2026-05-13.
//

import SwiftUI
import Firebase

struct ContentView: View {

    
    var body: some View {
        TabView {
            TodoView()
                .tabItem {
                    Label("Todo", systemImage: "list.bullet")
                }
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "bubble.right")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}
