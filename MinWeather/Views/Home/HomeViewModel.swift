//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Gregori Farias on 14/9/24.
//

import Foundation
import UIKit

class HomeViewModel: ObservableObject, UserLocationProtocol {
    private var locationManager: LocationManager?
    
    @Published var state: State = .loading
    @Published private(set) var imageName: String = ""
    @Published private(set) var dateDescription: String = ""
    @Published private(set) var cityName: String = ""
    @Published private(set) var temperature: Int = 0
    @Published private(set) var weatherKey: String = ""
    @Published private(set) var weatherDescription: String = ""
    @Published private(set) var humidity: Int = 0
    @Published private(set) var windSpeed: Int = 0
    @Published private(set) var visibility: Int = 0
    @Published var city: FetchCityResponse? = nil
    @Published var hasSearched = false
    
    enum State {
        case loading
        case loaded
        case error
    }
    
    private let openWeatherService: OpenWeatherService
    
    init(openWeatherService: OpenWeatherService, lat: Double? = nil, lon: Double? = nil) {
            self.openWeatherService = openWeatherService
            if let lat = lat, let lon = lon {
                fetchData(lat: lat, lon: lon)
            } else {
                fetchData(lat: nil, lon: nil)
            }
        }
    
    func fetchData(lat: Double?, lon: Double?) {
        
        if lat == nil && lon == nil {
            self.state = .loading
            self.locationManager = LocationManager(userLocationProtocol: self)
            self.locationManager?.requestPermission()
        } else {
            onUserLocationReceived(latitude: lat!, longitude: lon!) 
        }
    }
    
    
    func onUserLocationPermissionGranted() {
        self.state = .loading
        self.locationManager?.requestLocation()
    }
    
    func onUserLocationPermissionDenied() {
        self.state = .error
    }
    
    func onUserLocationReceived(latitude: Double, longitude: Double) {
        self.state = .loading
        
        self.openWeatherService.fetchWeatherData(lat: latitude, lon: longitude) { response, error in
            if error != nil {
                self.state = .error
                return
            }
            
            if let data = response {
                DispatchQueue.main.async {
                    let date = Date(timeIntervalSince1970: TimeInterval(data.dt))
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMMM d, YYYY"
                    
                    self.dateDescription = formatter.string(from: date)
                    self.cityName = data.name
                    self.temperature = Int(data.main.temp)
                    self.weatherKey = data.weather.first!.main
                    self.weatherDescription = data.weather.first!.description.capitalized
                    self.humidity = data.main.humidity
                    self.windSpeed = Int(data.wind.speed)
                    self.visibility = data.visibility / 1000
                    
                    let imagePrefix = data.weather.first!.icon.last!
                    let imageName = "\(imagePrefix)_\(self.weatherKey)"
                    
                    if (UIImage(named: imageName) != nil) {
                        self.imageName = imageName
                    } else {
                        // Workaround for unexpected types
                        self.imageName = "\(imagePrefix)_Clouds"
                    }
                    
                    self.state = .loaded
                    self.saveData(latitude, longitude)
                }
            } else {
                self.state = .error
            }
        }
    }
    
    func onUserLocationError() {
        self.state = .error
    }
    
    func fetchCity(cityName: String) {
        self.openWeatherService.fetchCity(cityName: cityName) { response, error in
            if let error = error {
                print("Error fetching city data: \(error)")
                self.city = nil
                self.hasSearched = true
                return
            }
            if let data = response {
                DispatchQueue.main.async {
                    self.city = data
                }
            }
        }
    }
    //Function to save data in the userDefaults
    func saveData(_ latitude: Double, _ longitude: Double) {
        UserDefaults.standard.setValue(latitude, forKey: "lat")
        UserDefaults.standard.setValue(longitude, forKey: "lon")
    }
}
