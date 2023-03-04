//
//  HomeInteractorTests.swift
//  OpenWeatherTests
//
//  Created by Steven Chau on 3/3/23.
//

@testable import OpenWeather
import XCTest
import RIBs
import RxSwift

final class HomeInteractorTests: XCTestCase {

    private var homeInteractor: HomeInteractor!

    private var homePresenter: HomePresentableMock!
    private var mutableCityStream: MutableCityStreamingMock!
    private var cityProvider: CityProvidingMock!
    private var weatherService: WeatherServicingMock!
    private let disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()

        homePresenter = HomePresentableMock()
        mutableCityStream = MutableCityStreamingMock()
        cityProvider = CityProvidingMock()
        weatherService = WeatherServicingMock()
        
        homeInteractor = HomeInteractor(presenter: homePresenter,
                                        cityStream: mutableCityStream,
                                        cityProvider: cityProvider,
                                        weatherService: weatherService)
    }

    // MARK: - Tests

    func testCityStream_observingUpdate() {
        // Given
        XCTAssertEqual(mutableCityStream.updateNameCallCount, 0)
        
        var expected = false
        mutableCityStream.name
            .take(1)
            .subscribe(onNext: { _ in
                expected = true
            })
            .disposed(by: disposeBag)
        
        // When
        mutableCityStream.update(name: "cupertino")
        
        // Expect
        XCTAssertEqual(expected, true)
        XCTAssertEqual(mutableCityStream.updateNameCallCount, 1)
    }

    func testDidPerformSearchForQuery_callsGetWeatherForCity() {
        // Given
        XCTAssertEqual(weatherService.getWeatherForCityCallCount, 0)
        XCTAssertEqual(homePresenter.showSpinnerCallCount, 0)
        
        var expected = false
        weatherService.getWeatherForCityHandler = {
            expected = true
        }
        
        // When
        homeInteractor.didPeformSearchFor(query: "cupertino")
        
        // Expect
        XCTAssertEqual(expected, true)
        XCTAssertEqual(weatherService.getWeatherForCityCallCount, 1)
        XCTAssertEqual(homePresenter.showSpinnerCallCount, 1)
    }
}
