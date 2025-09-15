//
//  MockFirebaseService.swift
//  FreeStuff
//
//  Created by Aerhelle Torno on 9/9/25.
//

import Foundation
import Combine

// Mock Firebase Service for development and testing
// Replace this with the actual FirebaseService once Firebase is configured
class MockFirebaseService: ObservableObject {
    static let shared = MockFirebaseService()
    
    private init() {}
    
    // MARK: - Authentication
    func signInWithEmail(email: String, password: String) async throws -> User {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        if email == "test@example.com" && password == "password" {
            return User(uid: "mockUser", name: "Test User", email: email, city: "San Francisco")
        } else {
            throw NSError(domain: "MockFirebaseService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])
        }
    }
    
    func signUpWithEmail(email: String, password: String, name: String, city: String) async throws -> User {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        let user = User(uid: "mockUser_\(UUID().uuidString)", name: name, email: email, city: city)
        return user
    }
    
    func signInWithGoogle() async throws -> User {
        throw NSError(domain: "MockFirebaseService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Google Sign-In not implemented"])
    }
    
    func signInWithApple() async throws -> User {
        throw NSError(domain: "MockFirebaseService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Apple Sign-In not implemented"])
    }
    
    func signOut() throws {
        // Mock sign out - no actual action needed
    }
    
    func getCurrentUser() -> MockFirebaseUser? {
        return MockFirebaseUser(uid: "mockUser", email: "test@example.com")
    }
    
    // MARK: - User Management
    func getUser(uid: String) async throws -> User {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return User(uid: uid, name: "Mock User", email: "mock@example.com", city: "Mock City")
    }
    
    func saveUser(_ user: User) async throws {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        // Mock save - no actual action needed
    }
    
    // MARK: - Items
    func getItems() async throws -> [Item] {
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        return [
            Item(ownerId: "user1", title: "Vintage Books", description: "Collection of classic novels in good condition", category: .books, city: "San Francisco"),
            Item(ownerId: "user2", title: "Office Chair", description: "Comfortable ergonomic office chair, barely used", category: .furniture, city: "San Francisco"),
            Item(ownerId: "user3", title: "iPhone Case", description: "Clear protective case for iPhone 14", category: .electronics, city: "Oakland")
        ]
    }
    
    func getItemsByUser(uid: String) async throws -> [Item] {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        return [
            Item(ownerId: uid, title: "My Posted Item", description: "This is an item I posted", category: .other, city: "San Francisco")
        ]
    }
    
    func saveItem(_ item: Item) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        // Mock save - no actual action needed
    }
    
    func updateItemStatus(itemId: String, status: ItemStatus) async throws {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        // Mock update - no actual action needed
    }
    
    // MARK: - Claims
    func createClaim(_ claim: Claim) async throws {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        // Mock create - no actual action needed
    }
    
    func getClaimsForUser(uid: String) async throws -> [Claim] {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return []
    }
    
    func getClaimsForOwner(uid: String) async throws -> [Claim] {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return []
    }
    
    func updateClaimStatus(claimId: String, status: ClaimStatus) async throws {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        // Mock update - no actual action needed
    }
    
    // MARK: - Messages
    func createChat(_ chat: Chat) async throws {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        // Mock create - no actual action needed
    }
    
    func getChatsForUser(uid: String) async throws -> [Chat] {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return []
    }
    
    func getMessages(chatId: String) async throws -> [Message] {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return []
    }
    
    func sendMessage(_ message: Message) async throws {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        // Mock send - no actual action needed
    }
    
    // MARK: - Storage
    func uploadImage(_ imageData: Data, path: String) async throws -> String {
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        return "https://mock-storage.com/\(path)"
    }
    
    // MARK: - Reports
    func createReport(_ report: Report) async throws {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        // Mock create - no actual action needed
    }
    
    // MARK: - Real-time Listeners
    func listenToItems(completion: @escaping ([Item]) -> Void) {
        // Mock real-time updates
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion([
                Item(ownerId: "user1", title: "Real-time Item", description: "This item was added in real-time", category: .other, city: "San Francisco")
            ])
        }
    }
    
    func listenToMessages(chatId: String, completion: @escaping ([Message]) -> Void) {
        // Mock real-time messages
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion([
                Message(chatId: chatId, senderId: "user1", receiverId: "user2", content: "Hello! Is this item still available?")
            ])
        }
    }
}

// Mock Firebase User
struct MockFirebaseUser {
    let uid: String
    let email: String?
}
