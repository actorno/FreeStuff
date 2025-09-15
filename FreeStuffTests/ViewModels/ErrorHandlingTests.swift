//
//  ErrorHandlingTests.swift
//  FreeStuffTests
//
//  Created by Aerhelle Torno on 9/9/25.
//

import XCTest
@testable import FreeStuff

@MainActor
final class ErrorHandlingTests: XCTestCase {
    var itemViewModel: ItemViewModel!
    
    override func setUp() {
        super.setUp()
        itemViewModel = ItemViewModel()
    }
    
    override func tearDown() {
        itemViewModel = nil
        super.tearDown()
    }
    
    func testFirebaseIndexErrorHandling() {
        // Given: A Firebase index error
        let firebaseError = NSError(
            domain: "FirebaseError",
            code: 9,
            userInfo: [
                NSLocalizedDescriptionKey: "The query requires an index. You can create it here: https://console.firebase.google.com/v1/r/project/freestuff-16bd4/firestore/indexes?create_composite=Ck1wcm9qZWN0cy9mcmVlc3R1ZmYtMTZIZDQvZGF0YWJhc2VzLyhkZWZhdWx0KS9jb2xsZWN0aW9uR3JvdXBzL2I0ZW1zL2luZGV4ZXMvXxABGgoKBnN0YXR1cxABGg0KCXRpbWVzdGFtcBACGgwKCF9fbmFtZV9fEAI"
            ]
        )
        
        // When: We get the user-friendly error message
        let userFriendlyMessage = itemViewModel.getUserFriendlyErrorMessage(from: firebaseError)
        
        // Then: It should return a user-friendly message instead of the technical error
        XCTAssertEqual(userFriendlyMessage, "We're setting up the database. Please try again in a moment.")
        XCTAssertFalse(userFriendlyMessage.contains("firebase.google.com"))
        XCTAssertFalse(userFriendlyMessage.contains("index"))
    }
    
    func testNetworkErrorHandling() {
        // Given: A network error
        let networkError = NSError(
            domain: "NetworkError",
            code: -1009,
            userInfo: [
                NSLocalizedDescriptionKey: "The Internet connection appears to be offline."
            ]
        )
        
        // When: We get the user-friendly error message
        let userFriendlyMessage = itemViewModel.getUserFriendlyErrorMessage(from: networkError)
        
        // Then: It should return a user-friendly network message
        XCTAssertEqual(userFriendlyMessage, "Please check your internet connection and try again.")
    }
    
    func testPermissionErrorHandling() {
        // Given: A permission error
        let permissionError = NSError(
            domain: "PermissionError",
            code: 7,
            userInfo: [
                NSLocalizedDescriptionKey: "Missing or insufficient permissions."
            ]
        )
        
        // When: We get the user-friendly error message
        let userFriendlyMessage = itemViewModel.getUserFriendlyErrorMessage(from: permissionError)
        
        // Then: It should return a user-friendly permission message
        XCTAssertEqual(userFriendlyMessage, "You don't have permission to perform this action.")
    }
    
    func testUnknownErrorHandling() {
        // Given: An unknown error
        let unknownError = NSError(
            domain: "UnknownError",
            code: 999,
            userInfo: [
                NSLocalizedDescriptionKey: "Some random technical error message"
            ]
        )
        
        // When: We get the user-friendly error message
        let userFriendlyMessage = itemViewModel.getUserFriendlyErrorMessage(from: unknownError)
        
        // Then: It should return the default unknown error message
        XCTAssertEqual(userFriendlyMessage, "Something went wrong. Please try again.")
    }
}
