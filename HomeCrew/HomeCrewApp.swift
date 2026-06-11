//
//  HomeCrewApp.swift
//  HomeCrew
//
//  Created by Isaac Strandh on 2026-05-13.
//

import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct HomeCrewApp: App {

    // Saves the user's dark mode preference locally
    @AppStorage("darkModeEnabled") private var darkMode = false

    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @State private var authViewModel = AuthViewModel()
    @State private var chatNotificationViewModel = ChatNotificationViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.isSignedIn {
                    NavigationStack {
                        TodoView()
                    }
                } else {
                    NavigationStack {
                        LoginView()
                    }
                }
            }
            .environment(authViewModel)
            .environment(chatNotificationViewModel)
            .preferredColorScheme(darkMode ? .dark : .light)
            .onAppear {
                authViewModel.checkExistingSession()
            }
        }
    }
}
