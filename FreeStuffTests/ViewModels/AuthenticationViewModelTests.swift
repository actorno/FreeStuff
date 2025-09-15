//
//  AuthenticationViewModelTests.swift
//  FreeStuffTests
//
//  Created by Aerhelle Torno on 9/9/25.
//

import XCTest
import Combine
@testable import FreeStuff

@MainActor
class AuthenticationViewModelTests: XCTestCase {
    var viewModel: AuthenticationViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = AuthenticationViewModel()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertNil(viewModel.currentUser)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testSignInWithValidCredentials() {
        // Given
        let email = "test@example.com"
        let password = "password123"
        
        // When
        viewModel.signIn(email: email, password: password)
        
        // Then
        XCTAssertTrue(viewModel.isLoading)
    }
    
    func testSignUpWithValidData() {
        // Given
        let email = "newuser@example.com"
        let password = "password123"
        let name = "Test User"
        
        // When
        viewModel.signUp(email: email, password: password, name: name)
        
        // Then
        XCTAssertTrue(viewModel.isLoading)
    }
    
    func testSignOut() {
        // Given
        viewModel.isAuthenticated = true
        viewModel.currentUser = User(uid: "test", name: "Test", email: "test@test.com", city: "Test City")
        
        // When
        viewModel.signOut()
        
        // Then
        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertNil(viewModel.currentUser)
    }
    
    func testErrorHandling() {
        // Given
        let expectation = XCTestExpectation(description: "Error message should be set")
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                if errorMessage != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        viewModel.signIn(email: "invalid", password: "invalid")
        
        // Then
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCheckAuthenticationStatusWithInvalidUser() {
        // Given
        let expectation = XCTestExpectation(description: "Authentication status should be checked")
        
        viewModel.$isAuthenticated
            .dropFirst()
            .sink { isAuthenticated in
                // Should remain false if user data is invalid
                XCTAssertFalse(isAuthenticated)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        viewModel.checkAuthenticationStatus()
        
        // Then
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSignInLoadingState() {
        // Given
        let expectation = XCTestExpectation(description: "Loading state should change")
        var loadingStates: [Bool] = []
        
        viewModel.$isLoading
            .sink { isLoading in
                loadingStates.append(isLoading)
                if loadingStates.count >= 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        viewModel.signIn(email: "test@example.com", password: "password")
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(loadingStates.contains(true), "Loading state should be true at some point")
    }
    
    func testSignUpLoadingState() {
        // Given
        let expectation = XCTestExpectation(description: "Loading state should change")
        var loadingStates: [Bool] = []
        
        viewModel.$isLoading
            .sink { isLoading in
                loadingStates.append(isLoading)
                if loadingStates.count >= 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        viewModel.signUp(email: "test@example.com", password: "password", name: "Test User")
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(loadingStates.contains(true), "Loading state should be true at some point")
    }
}
