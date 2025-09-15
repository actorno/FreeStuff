//
//  ClaimedItemsView.swift
//  FreeStuff
//
//  Created by Aerhelle Torno on 9/9/25.
//

import SwiftUI

struct ClaimedItemsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var claimedItems: [Item] = [] // This would come from claims data
    
    var body: some View {
        NavigationView {
            VStack {
                if claimedItems.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "hand.raised")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No claimed items yet")
                            .font(.title2)
                            .fontWeight(.medium)
                        Text("Start claiming items from your community!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                } else {
                    List(claimedItems) { item in
                        ClaimedItemCardView(item: item)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Claimed Items")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ClaimedItemCardView: View {
    let item: Item
    
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
                    
                    Text("Claimed")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.2))
                        .foregroundColor(.green)
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
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    ClaimedItemsView()
}
