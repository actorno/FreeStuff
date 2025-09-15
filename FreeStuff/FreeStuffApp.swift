//
//  FreeStuffApp.swift
//  FreeStuff
//
//  Created by Aerhelle Torno on 9/9/25.
//

import SwiftUI
import Firebase

@main
struct FreeStuffApp: App {
    @StateObject private var authViewModel = AuthenticationViewModel()
    
    init() {
        // Configure Firebase
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.showSplashScreen {
                    SplashScreenView()
                } else if authViewModel.isAuthenticated {
                    MainTabView()
                } else {
                    LoginView()
                }
            }
            .environmentObject(authViewModel)
        }
    }
}