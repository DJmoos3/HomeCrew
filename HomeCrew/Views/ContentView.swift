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
            
            Tab("Todo", systemImage: "list.bullet") {
                TodoView()
            }
            
            Tab("Chat", systemImage: "bubble.right") {
                ChatView()
            }
            
            Tab("Profile", systemImage: "person.crop.circle") {
                ProfileView()
            }
            
        }
    }
}

#Preview {
    ContentView()
}
