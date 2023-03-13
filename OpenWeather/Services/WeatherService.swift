//
//  HomeService.swift
//  OpenWeather
//
//  Created by Steven Chau on 3/2/23.
//

import Foundation
import CoreLocation
import UIKit

enum WeatherServiceError: Error {
    case invalidInput
    case invalidUrl
    case invalidData
    case invalidImage
}

protocol WeatherServicing {
    func getWeatherFor(city: String, completion: @escaping ((Result<WeatherResponseModel, Error>) -> Void))
    func getGeoFor(cLLocation: CLLocation, completion: @escaping ((Result<[GeolocationResponseModel], Error>) -> Void))
    func getWeatherIconFor(name: String, completion: @escaping ((Result<UIImage, Error>) -> Void))
}

class WeatherService: WeatherServicing {
    public static let shared = WeatherService()
    
    private init() {}
    
    public func getWeatherFor(city: String,
                              completion: @escaping ((Result<WeatherResponseModel, Error>) -> Void) ) {
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(WeatherServiceError.invalidInput))
            return
        }
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityEncoded)&units=imperial"
        guard let url = URL(string: urlString) else {
            completion(.failure(WeatherServiceError.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data else {
                completion(.failure(WeatherServiceError.invalidData))
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponseModel.self, from: data)
                completion(.success(weatherResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func getGeoFor(cLLocation: CLLocation,
                          completion: @escaping ((Result<[GeolocationResponseModel], Error>) -> Void) ) {
        let urlString = "http://api.openweathermap.org/geo/1.0/reverse?lat=\(cLLocation.coordinate.latitude)&lon=\(cLLocation.coordinate.longitude)&limit=5"
        guard let url = URL(string: urlString) else {
            completion(.failure(WeatherServiceError.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data else {
                completion(.failure(WeatherServiceError.invalidData))
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode([GeolocationResponseModel].self, from: data)
                completion(.success(weatherResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    public func getWeatherIconFor(name: String, completion: @escaping ((Result<UIImage, Error>) -> Void)) {
        let urlString = "http://openweathermap.org/img/wn/\(name)@2x.png"
        guard let url = URL(string: urlString) else {
            completion(.failure(WeatherServiceError.invalidUrl))
            return
        }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        // Check if resource is in cache
        if let cachedResponse = URLSession.shared.configuration.urlCache?.cachedResponse(for: request) {
            if let image = UIImage(data: cachedResponse.data) {
                completion(.success(image))
                return
            }
        }
        
        // Else fetch resource
        let session = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(WeatherServiceError.invalidData))
                return
            }
            guard let image = UIImage(data: data) else {
                completion(.failure(WeatherServiceError.invalidImage))
                return
            }
            completion(.success(image))
        }
        session.resume()
    }
}
