//
//  HomeViewModelTests.swift
//  SuperWeatherTests
//
//  Created by Gregori Farias on 15/9/24.
//

import XCTest
import Alamofire
@testable import SuperWeather

final class HomeViewModelTests: XCTestCase {

    var mockWeatherService: OpenWeatherService!
       var viewModel: HomeViewModel!
       
       override func setUp() {
           super.setUp()
           mockWeatherService = MockWeatherService()
           viewModel = HomeViewModel(openWeatherService: mockWeatherService, lat: 10.0, lon: 20.0)
       }
       
       func testInitialState_IsLoading() {
           XCTAssertEqual(viewModel.state, .loading)
       }
       
       func testFetchWeatherData_Success() {
           let expectation = self.expectation(description: "Weather data fetch successful")
           
           viewModel.fetchData(lat: 10.0, lon: 20.0)
           
           DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               XCTAssertEqual(self.viewModel.cityName, "Test City")
               XCTAssertEqual(self.viewModel.temperature, 25)
               XCTAssertEqual(self.viewModel.weatherKey, "Clouds")
               XCTAssertEqual(self.viewModel.state, .loaded)
               expectation.fulfill()
           }
           
           waitForExpectations(timeout: 5, handler: nil)
       }
       
       func testFetchCity_Success() {
           let expectation = self.expectation(description: "Fetch city data success")
           
           viewModel.fetchCity(cityName: "London")
           
           DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               XCTAssertEqual(self.viewModel.city?.name, "London")
               expectation.fulfill()
           }
           
           waitForExpectations(timeout: 5, handler: nil)
       }
   }

   class MockWeatherService: OpenWeatherService {
       
       var shouldReturnError = false
       
       override func fetchWeatherData(lat: Double, lon: Double, completion: @escaping (FetchWeatherDataResponse?, Error?) -> Void) {
           if shouldReturnError {
               completion(nil, OpenWeatherError.invalidResponse)
           } else {
               let mockResponse = FetchWeatherDataResponse(
                   name: "Test City",
                   weather: [FetchWeatherDataResponse.WeatherItem(main: "Clouds", description: "cloudy", icon: "01d")],
                   main: FetchWeatherDataResponse.WeatherMain(temp: 25.0, humidity: 60),
                   wind: FetchWeatherDataResponse.Wind(speed: 5.0),
                   visibility: 10000,
                   dt: 1620000000
               )
               completion(mockResponse, nil)
           }
       }
       
       override func fetchCity(cityName: String, completion: @escaping (FetchCityResponse?, Error?) -> Void) {
           if shouldReturnError {
               completion(nil, OpenWeatherError.invalidResponse)
           } else {
               let mockCityResponse = FetchCityResponse(
                   coord: FetchCityResponse.Coordinates(lon: -0.13, lat: 51.51),
                   name: "London",
                   id: 2643743
               )
               completion(mockCityResponse, nil)
           }
       }
   }
