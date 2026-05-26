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
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @State private var authViewModel = AuthViewModel()

    
    var body: some Scene {
        WindowGroup {
            //            NavigationStack {
            //                ContentView()
            //            }
            //            .environmentObject(authViewModel)

            NavigationStack {
                LoginView()
                    .environment(authViewModel)
            }
        }
    }
}
