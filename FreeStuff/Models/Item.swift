//
//  Item.swift
//  FreeStuff
//
//  Created by Aerhelle Torno on 9/9/25.
//

import Foundation
// import FirebaseFirestore

enum ItemCategory: String, CaseIterable, Codable {
    case electronics = "Electronics"
    case furniture = "Furniture"
    case clothing = "Clothing"
    case books = "Books"
    case toys = "Toys"
    case home = "Home & Garden"
    case sports = "Sports & Recreation"
    case automotive = "Automotive"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .electronics: return "laptopcomputer"
        case .furniture: return "chair"
        case .clothing: return "tshirt"
        case .books: return "book"
        case .toys: return "gamecontroller"
        case .home: return "house"
        case .sports: return "sportscourt"
        case .automotive: return "car"
        case .other: return "questionmark.circle"
        }
    }
}

enum ItemStatus: String, Codable {
    case available = "available"
    case claimed = "claimed"
    case givenAway = "givenAway"
}

struct Item: Identifiable, Codable {
    var id: String?
    var itemId: String
    let ownerId: String
    let title: String
    let description: String
    var photos: [String] // URLs to Firebase Storage
    let category: ItemCategory
    let city: String
    var timestamp: Date
    var status: ItemStatus
    let latitude: Double?
    let longitude: Double?
    
    init(ownerId: String, title: String, description: String, category: ItemCategory, city: String, latitude: Double? = nil, longitude: Double? = nil) {
        self.itemId = UUID().uuidString
        self.ownerId = ownerId
        self.title = title
        self.description = description
        self.photos = []
        self.category = category
        self.city = city
        self.timestamp = Date()
        self.status = .available
        self.latitude = latitude
        self.longitude = longitude
    }
}

// MARK: - Firestore Extensions
extension Item {
    static let collection = "items"
    
    func toDictionary() -> [String: Any] {
        return [
            "itemId": itemId,
            "ownerId": ownerId,
            "title": title,
            "description": description,
            "photos": photos,
            "category": category.rawValue,
            "city": city,
            "timestamp": timestamp,
            "status": status.rawValue,
            "latitude": latitude as Any,
            "longitude": longitude as Any
        ]
    }
    
    static func fromDictionary(_ data: [String: Any]) -> Item? {
        guard let itemId = data["itemId"] as? String,
              let ownerId = data["ownerId"] as? String,
              let title = data["title"] as? String,
              let description = data["description"] as? String,
              let photos = data["photos"] as? [String],
              let categoryString = data["category"] as? String,
              let category = ItemCategory(rawValue: categoryString),
              let city = data["city"] as? String,
              let timestamp = data["timestamp"] as? Date,
              let statusString = data["status"] as? String,
              let status = ItemStatus(rawValue: statusString) else {
            return nil
        }
        
        let latitude = data["latitude"] as? Double
        let longitude = data["longitude"] as? Double
        
        var item = Item(ownerId: ownerId, title: title, description: description, category: category, city: city, latitude: latitude, longitude: longitude)
        item.itemId = itemId
        item.photos = photos
        item.timestamp = timestamp
        item.status = status
        return item
    }
}
