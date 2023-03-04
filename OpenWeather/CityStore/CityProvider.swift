//
//  CityProvider.swift
//  OpenWeather
//
//  Created by Steven Chau on 3/2/23.
//

import Foundation
import CoreLocation

// Responsible for providing the city name.
// Attempts to get it from the CityStore
// Else prompts the user for Location permission
// If successful, it updates the City stream
protocol CityProviding {
    func persistCity(_ cityName: String)
}


class CityProvider: NSObject, CityProviding {
    
    private var mutableCityStream: MutableCityStreaming?
    
    private lazy var cllocationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyReduced
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    public init(mutableCityStream: MutableCityStreaming) {
        self.mutableCityStream = mutableCityStream
        super.init()
        getCity()
    }
    
    private func getCity() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            if let persistedCityName = CityStore.shared.getCity() {
                self.updateCityStream(name: persistedCityName)
                return
            }
            DispatchQueue.main.async {
                self.promptUserLocationPermissionIfNeeded()
            }
        }
    }
    
    private func promptUserLocationPermissionIfNeeded() {
        cllocationManager.startUpdatingLocation()
    }
    
    private func updateCityStream(name: String?) {
        mutableCityStream?.update(name: name)
    }
    
    private func getCityFrom(coordinates: CLLocation) {
        WeatherService.shared.getGeoFor(cLLocation: coordinates) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let geolocationResponse):
                guard let cityName = geolocationResponse.first?.name else { return }
                self.updateCityStream(name: cityName)
                self.persistCity(cityName)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func persistCity(_ cityName: String) {
        DispatchQueue.global(qos: .userInteractive).async {
            CityStore.shared.setCity(cityName)
        }
    }
}

extension CityProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else { return }
        getCityFrom(coordinates: firstLocation)
    }
}
