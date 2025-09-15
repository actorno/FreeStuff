//
//  ChatListView.swift
//  FreeStuff
//
//  Created by Aerhelle Torno on 9/9/25.
//

import SwiftUI

struct ChatListView: View {
    @StateObject private var chatViewModel = ChatViewModel()
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var showingChat = false
    @State private var selectedChat: Chat?
    
    var body: some View {
        NavigationView {
            VStack {
                if chatViewModel.isLoading {
                    Spacer()
                    ProgressView("Loading chats...")
                    Spacer()
                } else if chatViewModel.chats.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "message")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No conversations yet")
                            .font(.title2)
                            .fontWeight(.medium)
                        Text("Start claiming items to begin chatting!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                } else {
                    List(chatViewModel.chats) { chat in
                        ChatRowView(chat: chat) {
                            selectedChat = chat
                            showingChat = true
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                if let userId = authViewModel.currentUser?.uid {
                    chatViewModel.loadChats(userId: userId)
                }
            }
        }
        .sheet(isPresented: $showingChat) {
            if let chat = selectedChat {
                ChatView(chat: chat)
            }
        }
    }
}

struct ChatRowView: View {
    let chat: Chat
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Avatar
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.blue)
                    )
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(chat.chatId) // This should be the other user's name
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    if let lastMessage = chat.lastMessage {
                        Text(lastMessage)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    } else {
                        Text("No messages yet")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                }
                
                Spacer()
                
                // Timestamp and unread count
                VStack(alignment: .trailing, spacing: 4) {
                    if let timestamp = chat.lastMessageTimestamp {
                        Text(timestamp, style: .relative)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Unread count would go here
                }
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ChatListView()
}
