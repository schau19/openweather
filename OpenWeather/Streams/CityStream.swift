//
//  DeviceLocationManager.swift
//  OpenWeather
//
//  Created by Steven Chau on 3/2/23.
//

import Foundation
import RxSwift

// Provides two streams for communication of the city name:

// Immutable stream. Observers can subscribe and listen to the events
protocol CityStreaming {
    var name: Observable<String?> { get }
}

// Mutable stream. Single component should be responsible for writing to the stream
protocol MutableCityStreaming: CityStreaming {
    func update(name: String?)
}

public class CityStream: MutableCityStreaming {
    public static let shared = CityStream()
    
    private init() {}
    
    public var name: Observable<String?> {
        return nameSubject.asObservable()
    }
    
    private let nameSubject = BehaviorSubject<String?>(value: nil)

    func update(name: String?) {
        nameSubject.onNext(name)
    }
}

