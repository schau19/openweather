//
//  HomeBuilder.swift
//  OpenWeather
//
//  Created by Steven Chau on 3/2/23.
//

import RIBs

protocol HomeDependency: Dependency {
    var mutableCityStream: MutableCityStreaming { get }
    var cityStream: CityStreaming { get }
}

final class HomeComponent: Component<HomeDependency> {}

// MARK: - Builder

protocol HomeBuildable: Buildable {
    func build() -> LaunchRouting
}

final class HomeBuilder: Builder<HomeDependency>, HomeBuildable {

    override init(dependency: HomeDependency) {
        super.init(dependency: dependency)
    }

    func build() -> LaunchRouting {
        let component = HomeComponent(dependency: dependency)
        let viewController = HomeViewController()
        
        let cityProvider = CityProvider(mutableCityStream: dependency.mutableCityStream)
        let interactor = HomeInteractor(presenter: viewController,
                                        cityStream: dependency.cityStream,
                                        cityProvider: cityProvider,
                                        weatherService: WeatherService.shared)
        return HomeRouter(interactor: interactor, viewController: viewController)
    }
}
