//
//  MyItemsView.swift
//  FreeStuff
//
//  Created by Aerhelle Torno on 9/9/25.
//

import SwiftUI

struct MyItemsView: View {
    @StateObject private var itemViewModel = ItemViewModel()
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                if itemViewModel.userItems.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "tray")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No items posted yet")
                            .font(.title2)
                            .fontWeight(.medium)
                        Text("Start sharing items with your community!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(itemViewModel.userItems) { item in
                            MyItemCardView(item: item) {
                                itemViewModel.markItemAsGivenAway(item)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("My Items")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let userId = authViewModel.currentUser?.uid {
                    itemViewModel.loadUserItems(userId: userId)
                }
            }
        }
    }
}

struct MyItemCardView: View {
    let item: Item
    let onMarkAsGivenAway: () -> Void
    @State private var showingMarkAsGivenAway = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Photo
            if let firstPhoto = item.photos.first, !firstPhoto.isEmpty {
                AsyncImage(url: URL(string: firstPhoto)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                }
                .frame(height: 150)
                .clipped()
                .cornerRadius(12)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 150)
                    .overlay(
                        VStack {
                            Image(systemName: item.category.icon)
                                .font(.system(size: 30))
                                .foregroundColor(.gray)
                            Text("No photo")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    )
                    .cornerRadius(12)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(item.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Text(item.status.rawValue.capitalized)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(statusColor.opacity(0.2))
                        .foregroundColor(statusColor)
                        .cornerRadius(8)
                }
                
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Label(item.category.rawValue, systemImage: item.category.icon)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(item.timestamp, style: .relative)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Action Button
            if item.status == .claimed {
                Button(action: {
                    showingMarkAsGivenAway = true
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Mark as Given Away")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .alert("Mark as Given Away", isPresented: $showingMarkAsGivenAway) {
            Button("Cancel", role: .cancel) { }
            Button("Confirm", role: .destructive) {
                onMarkAsGivenAway()
            }
        } message: {
            Text("Are you sure you want to mark this item as given away? This action cannot be undone.")
        }
    }
    
    private var statusColor: Color {
        switch item.status {
        case .available:
            return .green
        case .claimed:
            return .orange
        case .givenAway:
            return .gray
        }
    }
}

#Preview {
    MyItemsView()
}
