//
//  UserTests.swift
//  FreeStuffTests
//
//  Created by Aerhelle Torno on 9/9/25.
//

import XCTest
@testable import FreeStuff

class UserTests: XCTestCase {
    
    func testUserInitialization() {
        // Given
        let uid = "testUid"
        let name = "Test User"
        let email = "test@example.com"
        let city = "Test City"
        
        // When
        let user = User(uid: uid, name: name, email: email, city: city)
        
        // Then
        XCTAssertEqual(user.uid, uid)
        XCTAssertEqual(user.name, name)
        XCTAssertEqual(user.email, email)
        XCTAssertEqual(user.city, city)
        XCTAssertNotNil(user.joinDate)
    }
    
    func testUserToDictionary() {
        // Given
        let user = User(uid: "test", name: "Test User", email: "test@test.com", city: "Test City")
        
        // When
        let dictionary = user.toDictionary()
        
        // Then
        XCTAssertEqual(dictionary["uid"] as? String, "test")
        XCTAssertEqual(dictionary["name"] as? String, "Test User")
        XCTAssertEqual(dictionary["email"] as? String, "test@test.com")
        XCTAssertEqual(dictionary["city"] as? String, "Test City")
        XCTAssertNotNil(dictionary["joinDate"] as? Date)
    }
    
    func testUserFromDictionary() {
        // Given
        let joinDate = Date()
        let dictionary: [String: Any] = [
            "uid": "testUid",
            "name": "Test User",
            "email": "test@example.com",
            "joinDate": joinDate,
            "city": "Test City"
        ]
        
        // When
        let user = User.fromDictionary(dictionary)
        
        // Then
        XCTAssertNotNil(user)
        XCTAssertEqual(user?.uid, "testUid")
        XCTAssertEqual(user?.name, "Test User")
        XCTAssertEqual(user?.email, "test@example.com")
        XCTAssertEqual(user?.city, "Test City")
        XCTAssertEqual(user?.joinDate, joinDate)
    }
    
    func testUserFromDictionaryWithMissingFields() {
        // Given
        let dictionary: [String: Any] = [
            "uid": "testUid",
            "name": "Test User"
            // Missing required fields
        ]
        
        // When
        let user = User.fromDictionary(dictionary)
        
        // Then
        XCTAssertNil(user)
    }
    
    func testUserCollectionName() {
        // Then
        XCTAssertEqual(User.collection, "users")
    }
}
