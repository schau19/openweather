//
//  CityStore.swift
//  OpenWeather
//
//  Created by Steven Chau on 3/3/23.
//

import Foundation

// Responsible for storage

class CityStore {
    public static let shared = CityStore()
    
    private init() {}
    private let baseKey = "com.openweather.city"
    private var userDefaults = UserDefaults(suiteName: "com.openweather.city")
    
    public func getCity() -> String? {
        return userDefaults?.string(forKey: baseKey)
    }
    
    public func setCity(_ city: String) {
        userDefaults?.set(city, forKey: baseKey)
        
        // Note: User Defaults practices eventual consistency to disk, thus in a normal setting, Apple recommends not to call synchronize.
        // However, this is added for the sake of manual testing (e.g. terminating and launching the app), where we have a need to save to disk immediately
        userDefaults?.synchronize()
    }
}
