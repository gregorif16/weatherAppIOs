//
//  ViewModelFactory.swift
//  WeatherApp
//
//  Created by Gregori Farias on 14/9/24.
//

import Foundation

class ViewModelFactory {
    func makeHomeViewModel(latitud: Double?, Longitud: Double?) -> HomeViewModel {
        let openWeatherService = OpenWeatherService()
        if let latitud = latitud, let longitud = Longitud {
            return HomeViewModel(openWeatherService: openWeatherService, lat: latitud, lon: longitud)
        } else {
            return HomeViewModel(openWeatherService: openWeatherService)
        }
    }
}
