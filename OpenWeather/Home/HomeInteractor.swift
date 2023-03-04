//
//  HomeInteractor.swift
//  OpenWeather
//
//  Created by Steven Chau on 3/2/23.
//

import RIBs
import RxSwift

// Responsible for the business logic

protocol HomeRouting: ViewableRouting {}

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }
    func update(weatherViewModel: WeatherViewModel?)
    func showError(title: String, message: String)
    func showSpinner(_ show: Bool)
}

protocol HomeListener: AnyObject {}

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable {

    weak var router: HomeRouting?
    weak var listener: HomeListener?
    private let disposeBag = DisposeBag()
    
    private var cityName: String? = nil {
        didSet {
            let weatherViewModel = WeatherViewModel(name: cityName)
            presenter.update(weatherViewModel: weatherViewModel)
            
            guard let cityName = cityName else { return }
            getWeatherFor(city: cityName)
        }
    }
    private var weatherResponseModel: WeatherResponseModel? = nil {
        didSet {
            weatherViewModel = WeatherViewModel(name: weatherResponseModel?.name,
                                                headline: weatherResponseModel?.weather.first?.main,
                                                description: weatherResponseModel?.weather.first?.description,
                                                detail1: weatherResponseModel?.main.temp,
                                                detail2: weatherResponseModel?.main.temp_min,
                                                detail3: weatherResponseModel?.main.temp_max)
            
        }
    }
    
    private var weatherViewModel: WeatherViewModel? = nil {
        didSet {
            presenter.update(weatherViewModel: weatherViewModel)
        }
    }
    
    private let cityStream: CityStreaming
    private let cityProvider: CityProviding
    private let weatherService: WeatherServicing

    init(presenter: HomePresentable,
         cityStream: CityStreaming,
         cityProvider: CityProviding,
         weatherService: WeatherServicing) {
        self.cityStream = cityStream
        self.weatherService = weatherService
        self.cityProvider = cityProvider
        
        super.init(presenter: presenter)
        presenter.listener = self
        
        setupObservers()
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    private func setupObservers() {
        cityStream
            .name
            .observeOn(MainScheduler())
            .subscribe(onNext: { name in
                self.cityName = name
            })
            .disposed(by: disposeBag)
    }
    
    private func getWeatherFor(city: String) {
        presenter.showSpinner(true)
        weatherService.getWeatherFor(city: city) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.presenter.showSpinner(false)
                switch response {
                case .success(let weatherResponse):
                    self.weatherResponseModel = weatherResponse
                    self.getWeatherIconFor(name: weatherResponse.weather.first?.icon)
                    
                    // Persist city when we get valid response from service (to ensure we are not persisting invalid city)
                    self.cityProvider.persistCity(weatherResponse.name)
                case .failure(let error):
                    switch error {
                    case WeatherServiceError.invalidUrl:
                        self.presenter.showError(title: "Invalid city", message: "Please try again")
                    default:
                        self.presenter.showError(title: "Unexpected input", message: "Please try again")
                    }
                }
            }
        }
    }
    
    public func getWeatherIconFor(name: String?) {
        guard let name = name else {
            weatherViewModel?.icon = nil
            presenter.update(weatherViewModel: self.weatherViewModel)
            return
        }
        weatherService.getWeatherIconFor(name: name) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                var icon: UIImage? = nil
                switch response {
                case .success(let image):
                    icon = image
                case .failure(let error):
                    print(error)
                }
                self.weatherViewModel?.icon = icon
                self.presenter.update(weatherViewModel: self.weatherViewModel)
            }
        }
            
    }
}

extension HomeInteractor: HomePresentableListener {
    func didPeformSearchFor(query: String?) {
        guard let query = query else { return }
        getWeatherFor(city: query)
    }
}
