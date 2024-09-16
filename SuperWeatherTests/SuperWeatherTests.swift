//
//  SuperWeatherTests.swift
//  SuperWeatherTests
//
//  Created by Gregori Farias on 15/9/24.
//

import XCTest
import Alamofire
@testable import SuperWeather

final class SuperWeatherTests: XCTestCase {

    var service: OpenWeatherService!
       var session: Session!
       
       override func setUp() {
           super.setUp()
           session = Session(configuration: .ephemeral)
           service = OpenWeatherService(session: session)
       }
       
       func testFetchWeatherData_Success() {
           // Mock a successful response
           let expectation = self.expectation(description: "Fetch weather data")
           
           let lat = 10.0
           let lon = 20.0
           
           service.fetchWeatherData(lat: lat, lon: lon) { response, error in
               XCTAssertNil(error, "Error should be nil")
               XCTAssertNotNil(response, "Response should not be nil")
               expectation.fulfill()
           }
           
           waitForExpectations(timeout: 5, handler: nil)
       }
       
       
       func testFetchCity_Success() {
           let expectation = self.expectation(description: "Fetch city data")
           
           service.fetchCity(cityName: "London") { response, error in
               XCTAssertNil(error, "Error should be nil")
               XCTAssertNotNil(response, "Response should not be nil")
               XCTAssertEqual(response?.name, "London")
               expectation.fulfill()
           }
           
           waitForExpectations(timeout: 5, handler: nil)
       }
}
