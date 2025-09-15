//
//  ItemViewModel.swift
//  FreeStuff
//
//  Created by Aerhelle Torno on 9/9/25.
//

import Foundation
import Combine
import UIKit
import CoreLocation

@MainActor
class ItemViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var userItems: [Item] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedCategory: ItemCategory?
    
    // User-friendly error messages
    private let userFriendlyErrors: [String: String] = [
        "index": "We're setting up the database. Please try again in a moment.",
        "permission": "You don't have permission to perform this action.",
        "network": "Please check your internet connection and try again.",
        "authentication": "Please sign in again to continue.",
        "storage": "There was an issue uploading your photos. Please try again.",
        "unknown": "Something went wrong. Please try again."
    ]
    
    private let firebaseService = FirebaseService.shared
    private let locationService = LocationService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadItems()
    }
    
    func loadItems() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedItems = try await firebaseService.getItems()
                await MainActor.run {
                    self.items = self.sortItemsByDistance(fetchedItems)
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = self.getUserFriendlyErrorMessage(from: error)
                    self.isLoading = false
                }
            }
        }
    }
    
    func loadUserItems(userId: String) {
        Task {
            do {
                let fetchedItems = try await firebaseService.getItemsByUser(uid: userId)
                await MainActor.run {
                    self.userItems = fetchedItems
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = self.getUserFriendlyErrorMessage(from: error)
                }
            }
        }
    }
    
    func postItem(title: String, description: String, category: ItemCategory, photos: [UIImage]) {
        guard let currentUser = getCurrentUser() else {
            errorMessage = "User not authenticated"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                var item = Item(
                    ownerId: currentUser.uid,
                    title: title,
                    description: description,
                    category: category,
                    city: locationService.currentCity,
                    latitude: locationService.currentLocation?.coordinate.latitude,
                    longitude: locationService.currentLocation?.coordinate.longitude
                )
                
                // Upload photos
                var photoUrls: [String] = []
                for (index, photo) in photos.enumerated() {
                    if let imageData = photo.jpegData(compressionQuality: 0.8) {
                        let path = "items/\(item.itemId)/photo_\(index).jpg"
                        let url = try await firebaseService.uploadImage(imageData, path: path)
                        photoUrls.append(url)
                    }
                }
                
                item.photos = photoUrls
                try await firebaseService.saveItem(item)
                
                await MainActor.run {
                    self.isLoading = false
                    self.loadItems() // Refresh the list
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = self.getUserFriendlyErrorMessage(from: error)
                    self.isLoading = false
                }
            }
        }
    }
    
    func claimItem(_ item: Item) {
        guard let currentUser = getCurrentUser() else {
            errorMessage = "User not authenticated"
            return
        }
        
        Task {
            do {
                let claim = Claim(itemId: item.itemId, claimerId: currentUser.uid, ownerId: item.ownerId)
                try await firebaseService.createClaim(claim)
                
                // Update item status to claimed
                try await firebaseService.updateItemStatus(itemId: item.itemId, status: .claimed)
                
                await MainActor.run {
                    self.loadItems() // Refresh the list
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = self.getUserFriendlyErrorMessage(from: error)
                }
            }
        }
    }
    
    func markItemAsGivenAway(_ item: Item) {
        Task {
            do {
                try await firebaseService.updateItemStatus(itemId: item.itemId, status: .givenAway)
                await MainActor.run {
                    self.loadUserItems(userId: item.ownerId)
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = self.getUserFriendlyErrorMessage(from: error)
                }
            }
        }
    }
    
    func filterItems(by category: ItemCategory?) {
        selectedCategory = category
        // Filtering logic will be handled in the view
    }
    
    func getFilteredItems() -> [Item] {
        if let category = selectedCategory {
            return items.filter { $0.category == category }
        }
        return items
    }
    
    private func sortItemsByDistance(_ items: [Item]) -> [Item] {
        guard let currentLocation = locationService.currentLocation else {
            return items
        }
        
        return items.sorted { item1, item2 in
            let distance1 = calculateDistance(to: item1)
            let distance2 = calculateDistance(to: item2)
            return distance1 < distance2
        }
    }
    
    private func calculateDistance(to item: Item) -> Double {
        guard let currentLocation = locationService.currentLocation,
              let itemLat = item.latitude,
              let itemLon = item.longitude else {
            return Double.infinity
        }
        
        let itemLocation = CLLocation(latitude: itemLat, longitude: itemLon)
        return locationService.calculateDistance(from: currentLocation, to: itemLocation)
    }
    
    private func getCurrentUser() -> User? {
        // This should be injected or accessed through a shared authentication state
        // For now, we'll return nil and handle it in the calling code
        return nil
    }
    
    func getUserFriendlyErrorMessage(from error: Error) -> String {
        let errorString = error.localizedDescription.lowercased()
        
        // Check for specific error types
        if errorString.contains("index") || errorString.contains("firestore") {
            return userFriendlyErrors["index"] ?? userFriendlyErrors["unknown"]!
        } else if errorString.contains("permission") || errorString.contains("unauthorized") {
            return userFriendlyErrors["permission"] ?? userFriendlyErrors["unknown"]!
        } else if errorString.contains("network") || errorString.contains("connection") {
            return userFriendlyErrors["network"] ?? userFriendlyErrors["unknown"]!
        } else if errorString.contains("auth") || errorString.contains("sign") {
            return userFriendlyErrors["authentication"] ?? userFriendlyErrors["unknown"]!
        } else if errorString.contains("storage") || errorString.contains("upload") {
            return userFriendlyErrors["storage"] ?? userFriendlyErrors["unknown"]!
        } else {
            return userFriendlyErrors["unknown"]!
        }
    }
}
