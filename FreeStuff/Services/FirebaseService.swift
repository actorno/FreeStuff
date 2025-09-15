//
//  FirebaseService.swift
//  FreeStuff
//
//  Created by Aerhelle Torno on 9/9/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class FirebaseService: ObservableObject {
    static let shared = FirebaseService()
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    private init() {
        // Firebase configuration will be handled in AppDelegate or App file
    }
    
    // MARK: - Authentication
    func signInWithEmail(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        
        // Try to get existing user document
        do {
            return try await getUser(uid: result.user.uid)
        } catch {
            // If user document doesn't exist, create it with basic info
            print("User document not found, creating new user document for uid: \(result.user.uid)")
            let user = User(
                uid: result.user.uid,
                name: result.user.displayName ?? "User",
                email: result.user.email ?? email,
                city: "Unknown"
            )
            try await saveUser(user)
            return user
        }
    }
    
    func signUpWithEmail(email: String, password: String, name: String, city: String) async throws -> User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = User(uid: result.user.uid, name: name, email: email, city: city)
        try await saveUser(user)
        return user
    }
    
    func signInWithGoogle() async throws -> User {
        // Google Sign-In implementation
        // Note: This requires GoogleSignIn SDK to be added to the project
        // Steps to implement:
        // 1. Add GoogleSignIn package dependency
        // 2. Configure GoogleService-Info.plist
        // 3. Add URL scheme to Info.plist
        // 4. Implement the actual Google Sign-In flow
        
        throw NSError(
            domain: "FirebaseService", 
            code: 1, 
            userInfo: [
                NSLocalizedDescriptionKey: "Google Sign-In is not yet configured. Please contact support or use email/password authentication."
            ]
        )
    }
    
    func signInWithApple() async throws -> User {
        // Apple Sign-In implementation
        // Note: This requires AuthenticationServices framework
        // Steps to implement:
        // 1. Import AuthenticationServices
        // 2. Configure Apple Sign-In capability in Xcode
        // 3. Implement the actual Apple Sign-In flow
        
        throw NSError(
            domain: "FirebaseService", 
            code: 1, 
            userInfo: [
                NSLocalizedDescriptionKey: "Apple Sign-In is not yet configured. Please contact support or use email/password authentication."
            ]
        )
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func getCurrentUser() -> FirebaseAuth.User? {
        return Auth.auth().currentUser
    }
    
    // MARK: - User Management
    func getUser(uid: String) async throws -> User {
        let document = try await db.collection(User.collection).document(uid).getDocument()
        guard let data = document.data(),
              let user = User.fromDictionary(data) else {
            throw NSError(domain: "FirebaseService", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }
        return user
    }
    
    func saveUser(_ user: User) async throws {
        try await db.collection(User.collection).document(user.uid).setData(user.toDictionary())
    }
    
    // MARK: - Items
    func getItems() async throws -> [Item] {
        let snapshot = try await db.collection(Item.collection)
            .whereField("status", isEqualTo: ItemStatus.available.rawValue)
            .order(by: "timestamp", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            Item.fromDictionary(document.data())
        }
    }
    
    func getItemsByUser(uid: String) async throws -> [Item] {
        let snapshot = try await db.collection(Item.collection)
            .whereField("ownerId", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            Item.fromDictionary(document.data())
        }
    }
    
    func saveItem(_ item: Item) async throws {
        try await db.collection(Item.collection).document(item.itemId).setData(item.toDictionary())
    }
    
    func updateItemStatus(itemId: String, status: ItemStatus) async throws {
        try await db.collection(Item.collection).document(itemId).updateData([
            "status": status.rawValue
        ])
    }
    
    // MARK: - Claims
    func createClaim(_ claim: Claim) async throws {
        try await db.collection(Claim.collection).document(claim.claimId).setData(claim.toDictionary())
    }
    
    func getClaimsForUser(uid: String) async throws -> [Claim] {
        let snapshot = try await db.collection(Claim.collection)
            .whereField("claimerId", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            Claim.fromDictionary(document.data())
        }
    }
    
    func getClaimsForOwner(uid: String) async throws -> [Claim] {
        let snapshot = try await db.collection(Claim.collection)
            .whereField("ownerId", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            Claim.fromDictionary(document.data())
        }
    }
    
    func updateClaimStatus(claimId: String, status: ClaimStatus) async throws {
        try await db.collection(Claim.collection).document(claimId).updateData([
            "status": status.rawValue
        ])
    }
    
    // MARK: - Messages
    func createChat(_ chat: Chat) async throws {
        try await db.collection(Chat.collection).document(chat.chatId).setData(chat.toDictionary())
    }
    
    func getChatsForUser(uid: String) async throws -> [Chat] {
        let snapshot = try await db.collection(Chat.collection)
            .whereField("ownerId", isEqualTo: uid)
            .getDocuments()
        
        let ownerChats = snapshot.documents.compactMap { document in
            Chat.fromDictionary(document.data())
        }
        
        let claimerSnapshot = try await db.collection(Chat.collection)
            .whereField("claimerId", isEqualTo: uid)
            .getDocuments()
        
        let claimerChats = claimerSnapshot.documents.compactMap { document in
            Chat.fromDictionary(document.data())
        }
        
        return (ownerChats + claimerChats).sorted { $0.lastMessageTimestamp ?? Date.distantPast > $1.lastMessageTimestamp ?? Date.distantPast }
    }
    
    func getMessages(chatId: String) async throws -> [Message] {
        let snapshot = try await db.collection(Message.collection)
            .whereField("chatId", isEqualTo: chatId)
            .order(by: "timestamp", descending: false)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            Message.fromDictionary(document.data())
        }
    }
    
    func sendMessage(_ message: Message) async throws {
        try await db.collection(Message.collection).document(message.messageId).setData(message.toDictionary())
        
        // Update chat with last message
        try await db.collection(Chat.collection).document(message.chatId).updateData([
            "lastMessage": message.content,
            "lastMessageTimestamp": message.timestamp
        ])
    }
    
    // MARK: - Storage
    func uploadImage(_ imageData: Data, path: String) async throws -> String {
        let ref = storage.reference().child(path)
        let _ = try await ref.putDataAsync(imageData)
        return try await ref.downloadURL().absoluteString
    }
    
    // MARK: - Reports
    func createReport(_ report: Report) async throws {
        try await db.collection(Report.collection).document(report.reportId).setData(report.toDictionary())
    }
    
    // MARK: - Real-time Listeners
    func listenToItems(completion: @escaping ([Item]) -> Void) {
        db.collection(Item.collection)
            .whereField("status", isEqualTo: ItemStatus.available.rawValue)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }
                
                let items = documents.compactMap { document in
                    Item.fromDictionary(document.data())
                }
                completion(items)
            }
    }
    
    func listenToMessages(chatId: String, completion: @escaping ([Message]) -> Void) {
        db.collection(Message.collection)
            .whereField("chatId", isEqualTo: chatId)
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }
                
                let messages = documents.compactMap { document in
                    Message.fromDictionary(document.data())
                }
                completion(messages)
            }
    }
}
