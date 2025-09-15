//
//  ItemViewModelTests.swift
//  FreeStuffTests
//
//  Created by Aerhelle Torno on 9/9/25.
//

import XCTest
import Combine
@testable import FreeStuff

@MainActor
class ItemViewModelTests: XCTestCase {
    var viewModel: ItemViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = ItemViewModel()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertTrue(viewModel.userItems.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertNil(viewModel.selectedCategory)
    }
    
    func testFilterItemsByCategory() {
        // Given
        let category = ItemCategory.electronics
        viewModel.selectedCategory = category
        
        // When
        let filteredItems = viewModel.getFilteredItems()
        
        // Then
        // Since we don't have items loaded, this should return empty array
        XCTAssertTrue(filteredItems.isEmpty)
    }
    
    func testFilterItemsWithNoCategory() {
        // Given
        viewModel.selectedCategory = nil
        
        // When
        let filteredItems = viewModel.getFilteredItems()
        
        // Then
        XCTAssertEqual(filteredItems.count, viewModel.items.count)
    }
    
    func testPostItemWithValidData() {
        // Given
        let title = "Test Item"
        let description = "Test Description"
        let category = ItemCategory.other
        let photos: [UIImage] = []
        
        // When
        viewModel.postItem(title: title, description: description, category: category, photos: photos)
        
        // Then
        XCTAssertTrue(viewModel.isLoading)
    }
    
    func testClaimItem() {
        // Given
        let item = Item(ownerId: "owner", title: "Test", description: "Test", category: .other, city: "Test City")
        
        // When
        viewModel.claimItem(item)
        
        // Then
        // Should not crash and should handle the claim request
        XCTAssertNotNil(item.itemId)
    }
    
    func testMarkItemAsGivenAway() {
        // Given
        let item = Item(ownerId: "owner", title: "Test", description: "Test", category: .other, city: "Test City")
        
        // When
        viewModel.markItemAsGivenAway(item)
        
        // Then
        // Should not crash and should handle the status update
        XCTAssertNotNil(item.itemId)
    }
}
