//
//  //  WeatherApp.swift
//  WeatherApp
//
//  Created by Gregori Farias on 14/9/24.
//

import SwiftUI
import SwiftData

@main
struct WeatherApp: App {
    
    init() {
        // Fetch the saved location when the app launches
        fetchInitialLocation()
    }
    var body: some Scene {
        WindowGroup {
            let factory = ViewModelFactory()
            HomeView(viewModel: factory.makeHomeViewModel(latitud: savedLat, Longitud: savedLon))
        }
    }
    
    private var savedLat: Double?
    private var savedLon: Double?
    
    mutating func fetchInitialLocation() {
        if let lat = UserDefaults.standard.value(forKey: "lat") as? Double,
           let lon = UserDefaults.standard.value(forKey: "lon") as? Double {
            savedLat = lat
            savedLon = lon
        } else {
            savedLat = nil
            savedLon = nil
        }
    }
}

