//
//  ItemTests.swift
//  FreeStuffTests
//
//  Created by Aerhelle Torno on 9/9/25.
//

import XCTest
@testable import FreeStuff

class ItemTests: XCTestCase {
    
    func testItemInitialization() {
        // Given
        let ownerId = "testOwner"
        let title = "Test Item"
        let description = "Test Description"
        let category = ItemCategory.electronics
        let city = "Test City"
        
        // When
        let item = Item(ownerId: ownerId, title: title, description: description, category: category, city: city)
        
        // Then
        XCTAssertEqual(item.ownerId, ownerId)
        XCTAssertEqual(item.title, title)
        XCTAssertEqual(item.description, description)
        XCTAssertEqual(item.category, category)
        XCTAssertEqual(item.city, city)
        XCTAssertEqual(item.status, .available)
        XCTAssertTrue(item.photos.isEmpty)
        XCTAssertNotNil(item.itemId)
        XCTAssertNotNil(item.timestamp)
    }
    
    func testItemToDictionary() {
        // Given
        let item = Item(ownerId: "test", title: "Test", description: "Test", category: .other, city: "Test City")
        
        // When
        let dictionary = item.toDictionary()
        
        // Then
        XCTAssertEqual(dictionary["ownerId"] as? String, "test")
        XCTAssertEqual(dictionary["title"] as? String, "Test")
        XCTAssertEqual(dictionary["description"] as? String, "Test")
        XCTAssertEqual(dictionary["category"] as? String, "Other")
        XCTAssertEqual(dictionary["city"] as? String, "Test City")
        XCTAssertEqual(dictionary["status"] as? String, "available")
    }
    
    func testItemFromDictionary() {
        // Given
        let dictionary: [String: Any] = [
            "itemId": "testId",
            "ownerId": "testOwner",
            "title": "Test Item",
            "description": "Test Description",
            "photos": ["photo1.jpg", "photo2.jpg"],
            "category": "Electronics",
            "city": "Test City",
            "timestamp": Date(),
            "status": "available",
            "latitude": 37.7749,
            "longitude": -122.4194
        ]
        
        // When
        let item = Item.fromDictionary(dictionary)
        
        // Then
        XCTAssertNotNil(item)
        XCTAssertEqual(item?.itemId, "testId")
        XCTAssertEqual(item?.ownerId, "testOwner")
        XCTAssertEqual(item?.title, "Test Item")
        XCTAssertEqual(item?.description, "Test Description")
        XCTAssertEqual(item?.category, .electronics)
        XCTAssertEqual(item?.city, "Test City")
        XCTAssertEqual(item?.status, .available)
        XCTAssertEqual(item?.photos.count, 2)
    }
    
    func testItemCategoryIcon() {
        // Then
        XCTAssertEqual(ItemCategory.electronics.icon, "laptopcomputer")
        XCTAssertEqual(ItemCategory.furniture.icon, "chair")
        XCTAssertEqual(ItemCategory.clothing.icon, "tshirt")
        XCTAssertEqual(ItemCategory.books.icon, "book")
        XCTAssertEqual(ItemCategory.toys.icon, "gamecontroller")
        XCTAssertEqual(ItemCategory.home.icon, "house")
        XCTAssertEqual(ItemCategory.sports.icon, "sportscourt")
        XCTAssertEqual(ItemCategory.automotive.icon, "car")
        XCTAssertEqual(ItemCategory.other.icon, "questionmark.circle")
    }
    
    func testItemStatusValues() {
        // Then
        XCTAssertEqual(ItemStatus.available.rawValue, "available")
        XCTAssertEqual(ItemStatus.claimed.rawValue, "claimed")
        XCTAssertEqual(ItemStatus.givenAway.rawValue, "givenAway")
    }
}
