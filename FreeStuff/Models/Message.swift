//
//  Message.swift
//  FreeStuff
//
//  Created by Aerhelle Torno on 9/9/25.
//

import Foundation
// import FirebaseFirestore

struct Message: Identifiable, Codable {
    var id: String?
    var messageId: String
    let chatId: String
    let senderId: String
    let receiverId: String
    let content: String
    var timestamp: Date
    var isRead: Bool
    
    init(chatId: String, senderId: String, receiverId: String, content: String) {
        self.messageId = UUID().uuidString
        self.chatId = chatId
        self.senderId = senderId
        self.receiverId = receiverId
        self.content = content
        self.timestamp = Date()
        self.isRead = false
    }
}

struct Chat: Identifiable, Codable {
    var id: String?
    var chatId: String
    let itemId: String
    let ownerId: String
    let claimerId: String
    var lastMessage: String?
    var lastMessageTimestamp: Date?
    var ownerUnreadCount: Int
    var claimerUnreadCount: Int
    
    init(itemId: String, ownerId: String, claimerId: String) {
        self.chatId = UUID().uuidString
        self.itemId = itemId
        self.ownerId = ownerId
        self.claimerId = claimerId
        self.lastMessage = nil
        self.lastMessageTimestamp = nil
        self.ownerUnreadCount = 0
        self.claimerUnreadCount = 0
    }
}

// MARK: - Firestore Extensions
extension Message {
    static let collection = "messages"
    
    func toDictionary() -> [String: Any] {
        return [
            "messageId": messageId,
            "chatId": chatId,
            "senderId": senderId,
            "receiverId": receiverId,
            "content": content,
            "timestamp": timestamp,
            "isRead": isRead
        ]
    }
    
    static func fromDictionary(_ data: [String: Any]) -> Message? {
        guard let messageId = data["messageId"] as? String,
              let chatId = data["chatId"] as? String,
              let senderId = data["senderId"] as? String,
              let receiverId = data["receiverId"] as? String,
              let content = data["content"] as? String,
              let timestamp = data["timestamp"] as? Date,
              let isRead = data["isRead"] as? Bool else {
            return nil
        }
        
        var message = Message(chatId: chatId, senderId: senderId, receiverId: receiverId, content: content)
        message.messageId = messageId
        message.timestamp = timestamp
        message.isRead = isRead
        return message
    }
}

extension Chat {
    static let collection = "chats"
    
    func toDictionary() -> [String: Any] {
        return [
            "chatId": chatId,
            "itemId": itemId,
            "ownerId": ownerId,
            "claimerId": claimerId,
            "lastMessage": lastMessage as Any,
            "lastMessageTimestamp": lastMessageTimestamp as Any,
            "ownerUnreadCount": ownerUnreadCount,
            "claimerUnreadCount": claimerUnreadCount
        ]
    }
    
    static func fromDictionary(_ data: [String: Any]) -> Chat? {
        guard let chatId = data["chatId"] as? String,
              let itemId = data["itemId"] as? String,
              let ownerId = data["ownerId"] as? String,
              let claimerId = data["claimerId"] as? String,
              let ownerUnreadCount = data["ownerUnreadCount"] as? Int,
              let claimerUnreadCount = data["claimerUnreadCount"] as? Int else {
            return nil
        }
        
        let lastMessage = data["lastMessage"] as? String
        let lastMessageTimestamp = data["lastMessageTimestamp"] as? Date
        
        var chat = Chat(itemId: itemId, ownerId: ownerId, claimerId: claimerId)
        chat.chatId = chatId
        chat.lastMessage = lastMessage
        chat.lastMessageTimestamp = lastMessageTimestamp
        chat.ownerUnreadCount = ownerUnreadCount
        chat.claimerUnreadCount = claimerUnreadCount
        return chat
    }
}
