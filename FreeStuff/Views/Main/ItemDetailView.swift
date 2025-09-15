//
//  ItemDetailView.swift
//  FreeStuff
//
//  Created by Aerhelle Torno on 9/9/25.
//

import SwiftUI

struct ItemDetailView: View {
    let item: Item
    let onClaim: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var showingReport = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Photos
                    if !item.photos.isEmpty {
                        TabView {
                            ForEach(item.photos, id: \.self) { photoUrl in
                                AsyncImage(url: URL(string: photoUrl)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .overlay(
                                            ProgressView()
                                        )
                                }
                            }
                        }
                        .frame(height: 300)
                        .tabViewStyle(PageTabViewStyle())
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 200)
                            .overlay(
                                VStack {
                                    Image(systemName: item.category.icon)
                                        .font(.system(size: 50))
                                        .foregroundColor(.gray)
                                    Text("No photos available")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            )
                            .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Title and Category
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.title)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            HStack {
                                Label(item.category.rawValue, systemImage: item.category.icon)
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                
                                Spacer()
                                
                                Text(item.city)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                            Text(item.description)
                                .font(.body)
                        }
                        
                        // Status and Date
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Details")
                                .font(.headline)
                            
                            HStack {
                                Text("Status:")
                                    .fontWeight(.medium)
                                Text(item.status.rawValue.capitalized)
                                    .foregroundColor(statusColor)
                            }
                            
                            HStack {
                                Text("Posted:")
                                    .fontWeight(.medium)
                                Text(item.timestamp, style: .date)
                            }
                        }
                        
                        // Claim Button
                        if item.status == .available {
                            Button(action: onClaim) {
                                HStack {
                                    Image(systemName: "hand.raised.fill")
                                    Text("Claim This Item")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                        } else {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.gray)
                                Text("This item has been claimed")
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingReport = true
                    }) {
                        Image(systemName: "flag")
                    }
                }
            }
        }
        .sheet(isPresented: $showingReport) {
            ReportView(targetId: item.itemId, targetType: .item)
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
    ItemDetailView(
        item: Item(
            ownerId: "test",
            title: "Sample Item",
            description: "This is a sample item description",
            category: .electronics,
            city: "San Francisco"
        ),
        onClaim: {}
    )
}
