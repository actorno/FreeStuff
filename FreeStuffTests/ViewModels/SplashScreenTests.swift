//
//  SplashScreenTests.swift
//  FreeStuffTests
//
//  Created by Aerhelle Torno on 9/9/25.
//

import XCTest
@testable import FreeStuff

@MainActor
final class SplashScreenTests: XCTestCase {
    var authViewModel: AuthenticationViewModel!
    
    override func setUp() {
        super.setUp()
        authViewModel = AuthenticationViewModel()
    }
    
    override func tearDown() {
        authViewModel = nil
        super.tearDown()
    }
    
    func testSplashScreenInitialState() {
        // Given: A new AuthenticationViewModel
        // When: The view model is initialized
        // Then: The splash screen should be showing
        XCTAssertTrue(authViewModel.showSplashScreen, "Splash screen should be showing initially")
        XCTAssertFalse(authViewModel.isAuthenticated, "User should not be authenticated initially")
    }
    
    func testSplashScreenStateTransition() {
        // Given: A new AuthenticationViewModel with splash screen showing
        XCTAssertTrue(authViewModel.showSplashScreen)
        
        // When: We manually set the splash screen to false
        authViewModel.showSplashScreen = false
        
        // Then: The splash screen should be hidden
        XCTAssertFalse(authViewModel.showSplashScreen, "Splash screen should be hidden after transition")
    }
    
    func testSplashScreenDuration() {
        // Given: A new AuthenticationViewModel
        let expectation = XCTestExpectation(description: "Splash screen should hide after minimum duration")
        
        // When: We wait for the authentication check to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            // Then: The splash screen should be hidden
            XCTAssertFalse(self.authViewModel.showSplashScreen, "Splash screen should be hidden after minimum duration")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
}
