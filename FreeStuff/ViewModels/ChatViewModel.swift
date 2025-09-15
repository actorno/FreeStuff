//
//  ChatViewModel.swift
//  FreeStuff
//
//  Created by Aerhelle Torno on 9/9/25.
//

import Foundation
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    @Published var messages: [Message] = []
    @Published var currentChat: Chat?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var newMessageText = ""
    
    private let firebaseService = FirebaseService.shared
    private var cancellables = Set<AnyCancellable>()
    
    func loadChats(userId: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedChats = try await firebaseService.getChatsForUser(uid: userId)
                await MainActor.run {
                    self.chats = fetchedChats
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
    
    func loadMessages(chatId: String) {
        Task {
            do {
                let fetchedMessages = try await firebaseService.getMessages(chatId: chatId)
                await MainActor.run {
                    self.messages = fetchedMessages
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func startChat(itemId: String, ownerId: String, claimerId: String) {
        Task {
            do {
                let chat = Chat(itemId: itemId, ownerId: ownerId, claimerId: claimerId)
                try await firebaseService.createChat(chat)
                
                await MainActor.run {
                    self.currentChat = chat
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func sendMessage(chatId: String, senderId: String, receiverId: String) {
        guard !newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let message = Message(
            chatId: chatId,
            senderId: senderId,
            receiverId: receiverId,
            content: newMessageText.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        Task {
            do {
                try await firebaseService.sendMessage(message)
                await MainActor.run {
                    self.newMessageText = ""
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func listenToMessages(chatId: String) {
        firebaseService.listenToMessages(chatId: chatId) { [weak self] messages in
            Task { @MainActor in
                self?.messages = messages
            }
        }
    }
    
    func getOtherUserId(in chat: Chat, currentUserId: String) -> String {
        return chat.ownerId == currentUserId ? chat.claimerId : chat.ownerId
    }
    
    func getChatTitle(for chat: Chat, currentUserId: String) -> String {
        // This would typically fetch the other user's name
        // For now, return a placeholder
        return "Chat"
    }
}
