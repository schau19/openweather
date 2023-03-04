//
//  AppComponent.swift
//  OpenWeather
//
//  Created by Steven Chau on 3/2/23.
//

import RIBs

class AppComponent: Component<EmptyDependency>, HomeDependency {
    
    public var cityStream: CityStreaming {
        mutableCityStream
    }
    
    public var mutableCityStream: MutableCityStreaming {
        CityStream.shared
    }
    
    init() {
        super.init(dependency: EmptyComponent())
    }
}
