//
//  OpenWeatherMocks.swift
//  OpenWeatherTests
//
//  Created by Steven Chau on 3/3/23.
//

import CoreLocation
import Foundation
@testable import OpenWeather
import RIBs
import RxSwift

class HomePresentableListenerMock: HomePresentableListener {
    private(set) var didPeformSearchForQueryCallCount: Int = 0
    
    func didPeformSearchFor(query: String?) {
        didPeformSearchForQueryCallCount += 1
    }
}

class HomePresentableMock: HomePresentable {
    var listener: HomePresentableListener?
    
    init() {}
    
    private let listenerMock = HomePresentableListenerMock()
    
    private(set) var updateWeatherViewModelCallCount: Int = 0
    func update(weatherViewModel: WeatherViewModel?) {
        updateWeatherViewModelCallCount += 1
    }
    
    private(set) var showErrorTitleCallCount: Int = 0
    func showError(title: String, message: String) {
        showErrorTitleCallCount += 1
    }
    
    private(set) var showSpinnerCallCount: Int = 0
    func showSpinner(_ show: Bool) {
        showSpinnerCallCount += 1
    }
}

class CityStreamingMock: CityStreaming {
    
    init() {}
    
    var name: Observable<String?> {
        return nameSubject.asObservable()
    }
    
    private let nameSubject = BehaviorSubject<String?>(value: nil)
}

class MutableCityStreamingMock: CityStreamingMock, MutableCityStreaming {

    private(set) var updateNameCallCount: Int = 0
    func update(name: String?) {
        updateNameCallCount += 1
    }
}

class CityProvidingMock: CityProviding {
    
    init() {}
    
    private(set) var persistCityCallCount: Int = 0
    func persistCity(_ cityName: String) {
        persistCityCallCount += 1
    }
}

class WeatherServicingMock: WeatherServicing {
    
    init() {}
    
    var getWeatherForCityHandler: (() -> ())?

    private(set) var getWeatherForCityCallCount: Int = 0
    func getWeatherFor(city: String, completion: @escaping ((Result<WeatherResponseModel, Error>) -> Void)) {
        getWeatherForCityCallCount += 1
        if let getWeatherForCityHandler = getWeatherForCityHandler {
            return getWeatherForCityHandler()
        }
    }
    
    private(set) var getGeoForCLLocationCallCount: Int = 0
    func getGeoFor(cLLocation: CLLocation, completion: @escaping ((Result<[GeolocationResponseModel], Error>) -> Void)) {
        getGeoForCLLocationCallCount += 1
    }
    
    private(set) var getWeatherIconForNameCallCount: Int = 0
    func getWeatherIconFor(name: String, completion: @escaping ((Result<UIImage, Error>) -> Void)) {
        getWeatherIconForNameCallCount += 1
    }
}
