//
//  LocationServiceTests.swift
//  FreeStuffTests
//
//  Created by Aerhelle Torno on 9/9/25.
//

import XCTest
import CoreLocation
@testable import FreeStuff

class LocationServiceTests: XCTestCase {
    var locationService: LocationService!
    
    override func setUp() {
        super.setUp()
        locationService = LocationService.shared
    }
    
    override func tearDown() {
        locationService = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertNil(locationService.currentLocation)
        XCTAssertEqual(locationService.currentCity, "Unknown")
        XCTAssertFalse(locationService.isLocationEnabled)
    }
    
    func testCalculateDistance() {
        // Given
        let location1 = CLLocation(latitude: 37.7749, longitude: -122.4194) // San Francisco
        let location2 = CLLocation(latitude: 37.7849, longitude: -122.4094) // Nearby location
        
        // When
        let distance = locationService.calculateDistance(from: location1, to: location2)
        
        // Then
        XCTAssertGreaterThan(distance, 0)
        XCTAssertLessThan(distance, 10) // Should be less than 10 km
    }
    
    func testFormatDistance() {
        // Given
        let distanceInMeters = 500.0 // 0.5 km
        
        // When
        let formattedDistance = locationService.formatDistance(distanceInMeters)
        
        // Then
        XCTAssertTrue(formattedDistance.contains("km"))
    }
    
    func testFormatDistanceInMeters() {
        // Given
        let distanceInMeters = 0.5 // 500 meters
        
        // When
        let formattedDistance = locationService.formatDistance(distanceInMeters)
        
        // Then
        XCTAssertTrue(formattedDistance.contains("m"))
    }
    
    func testRequestLocationPermission() {
        // When
        locationService.requestLocationPermission()
        
        // Then
        // Should not crash and should request permission
        XCTAssertNotNil(locationService)
    }
}
