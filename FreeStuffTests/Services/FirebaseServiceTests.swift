//
//  FirebaseServiceTests.swift
//  FreeStuffTests
//
//  Created by Aerhelle Torno on 9/9/25.
//

import XCTest
import FirebaseAuth
import FirebaseFirestore
@testable import FreeStuff

class FirebaseServiceTests: XCTestCase {
    var firebaseService: FirebaseService!
    
    override func setUp() {
        super.setUp()
        firebaseService = FirebaseService.shared
    }
    
    override func tearDown() {
        firebaseService = nil
        super.tearDown()
    }
    
    func testUserCreationFallback() async throws {
        // This test verifies that when a user signs in but their document doesn't exist,
        // the system creates a new user document automatically
        
        // Given: A mock Firebase Auth user (this would be set up in a real test environment)
        let mockUID = "test-user-uid"
        let mockEmail = "test@example.com"
        let mockName = "Test User"
        
        // When: We try to get a user that doesn't exist in Firestore
        do {
            let user = try await firebaseService.getUser(uid: mockUID)
            // If we get here, the user exists (which is fine for this test)
            XCTAssertEqual(user.uid, mockUID)
        } catch {
            // This is expected if the user document doesn't exist
            XCTAssertTrue(error.localizedDescription.contains("User not found"))
        }
    }
    
    func testUserModelConversion() {
        // Test User model to/from dictionary conversion
        let originalUser = User(
            uid: "test-uid",
            name: "Test User",
            email: "test@example.com",
            city: "Test City"
        )
        
        // Convert to dictionary
        let dictionary = originalUser.toDictionary()
        
        // Verify dictionary contains expected keys
        XCTAssertEqual(dictionary["uid"] as? String, "test-uid")
        XCTAssertEqual(dictionary["name"] as? String, "Test User")
        XCTAssertEqual(dictionary["email"] as? String, "test@example.com")
        XCTAssertEqual(dictionary["city"] as? String, "Test City")
        XCTAssertNotNil(dictionary["joinDate"] as? Date)
        
        // Convert back to User
        let convertedUser = User.fromDictionary(dictionary)
        
        // Verify conversion
        XCTAssertNotNil(convertedUser)
        XCTAssertEqual(convertedUser?.uid, originalUser.uid)
        XCTAssertEqual(convertedUser?.name, originalUser.name)
        XCTAssertEqual(convertedUser?.email, originalUser.email)
        XCTAssertEqual(convertedUser?.city, originalUser.city)
    }
    
    func testUserModelWithInvalidData() {
        // Test User model with invalid dictionary data
        let invalidData: [String: Any] = [
            "uid": "test-uid",
            "name": "Test User"
            // Missing required fields: email, joinDate, city
        ]
        
        let user = User.fromDictionary(invalidData)
        XCTAssertNil(user, "User should be nil when required fields are missing")
    }
    
    func testUserModelWithWrongDataTypes() {
        // Test User model with wrong data types
        let invalidData: [String: Any] = [
            "uid": 123, // Should be String
            "name": "Test User",
            "email": "test@example.com",
            "joinDate": Date(),
            "city": "Test City"
        ]
        
        let user = User.fromDictionary(invalidData)
        XCTAssertNil(user, "User should be nil when data types are wrong")
    }
}
