//
//  WeatherModel.swift
//  OpenWeather
//
//  Created by Steven Chau on 3/2/23.
//

import Foundation

struct WeatherResponseModel: Codable {
    let weather: [WeatherModel]
    let main: MainModel
    let name: String
}

struct WeatherModel: Codable {
    let main: String
    let description: String
    let icon: String
}

struct MainModel: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}
