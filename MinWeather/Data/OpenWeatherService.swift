//
//  OpenWeatherService.swift
//  WeatherApp
//
//  Created by Gregori Farias on 14/9/24.
//

import Foundation
import Alamofire

//MARK: -Models 

struct FetchWeatherDataResponse: Codable {
    let name: String
    let weather: [WeatherItem]
    let main: WeatherMain
    let wind: Wind
    let visibility: Int
    let dt: Int
    
    struct WeatherItem: Codable {
        let main: String
        let description: String
        let icon: String
    }

    struct WeatherMain: Codable {
        let temp: Double
        let humidity: Int
    }

    struct Wind: Codable {
        let speed: Double
    }
}


struct FetchCityResponse: Codable {
    struct Coordinates: Codable {
        let lon: Double
        let lat: Double
    }

    let coord: Coordinates
    let name: String
    let id: Int
}

//MARK: -Errors

enum OpenWeatherError: Error {
    case networkError(Error)
    case decodingError(Error)
    case invalidResponse
}


//MARK: -Call

class OpenWeatherService {
    private let baseUrl = "https://api.openweathermap.org/data/2.5"
    private let session: Session
    let api_key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    
    init(session: Session = .default) {
        self.session = session
    }
    
    //MARK: - Fetch data with users location
    func fetchWeatherData(lat: Double, lon: Double, completion: @escaping (FetchWeatherDataResponse?, Error?) -> Void) {
        
        let endpoint = "/weather"
        let queryParams = "?lat=\(lat)&lon=\(lon)&appid=\(api_key)&units=metric"
        let url = "\(self.baseUrl)\(endpoint)\(queryParams)"
        
        session.request(url)
            .validate()
            .responseDecodable(of: FetchWeatherDataResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    

//MARK: - Fetch data with city name
    
    func fetchCity(cityName: String, completion: @escaping (FetchCityResponse?, Error?) -> Void) {
        let endpoint = "/weather"
        let url = "\(baseUrl)\(endpoint)?q=\(cityName)&appid=\(api_key)"
        session.request(url)
            .validate()
            .responseDecodable(of: FetchCityResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
}
