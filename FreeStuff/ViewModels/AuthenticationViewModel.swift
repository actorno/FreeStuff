//
//  AuthenticationViewModel.swift
//  FreeStuff
//
//  Created by Aerhelle Torno on 9/9/25.
//

import Foundation
import Combine
import FirebaseAuth

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showSplashScreen = true
    
    private let firebaseService = FirebaseService.shared
    private let locationService = LocationService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        checkAuthenticationStatus()
    }
    
    func checkAuthenticationStatus() {
        // Show splash screen for minimum duration
        Task {
            // Wait for minimum splash screen duration (2 seconds)
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            
            if let firebaseUser = firebaseService.getCurrentUser() {
                do {
                    let user = try await firebaseService.getUser(uid: firebaseUser.uid)
                    await MainActor.run {
                        self.currentUser = user
                        self.isAuthenticated = true
                        self.showSplashScreen = false
                    }
                } catch {
                    // If user document doesn't exist, sign out the user
                    // This will force them to sign in again, which will create the document
                    await MainActor.run {
                        self.errorMessage = "User data not found. Please sign in again."
                        self.isAuthenticated = false
                        self.currentUser = nil
                        self.showSplashScreen = false
                    }
                    // Sign out from Firebase Auth to clear the invalid session
                    try? firebaseService.signOut()
                }
            } else {
                await MainActor.run {
                    self.isAuthenticated = false
                    self.showSplashScreen = false
                }
            }
        }
    }
    
    func signIn(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let user = try await firebaseService.signInWithEmail(email: email, password: password)
                await MainActor.run {
                    self.currentUser = user
                    self.isAuthenticated = true
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func signUp(email: String, password: String, name: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let city = locationService.currentCity
                let user = try await firebaseService.signUpWithEmail(email: email, password: password, name: name, city: city)
                await MainActor.run {
                    self.currentUser = user
                    self.isAuthenticated = true
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func signInWithGoogle() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let user = try await firebaseService.signInWithGoogle()
                await MainActor.run {
                    self.currentUser = user
                    self.isAuthenticated = true
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func signInWithApple() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let user = try await firebaseService.signInWithApple()
                await MainActor.run {
                    self.currentUser = user
                    self.isAuthenticated = true
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func signOut() {
        do {
            try firebaseService.signOut()
            currentUser = nil
            isAuthenticated = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
