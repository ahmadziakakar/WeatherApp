//
//  WeatherMapViewModel.swift
//  WeatherMap
//
//  Created by Zia Kakar on 12/23/21.
//

import Foundation
import Combine
import CoreLocation

class WeatherMapViewModel {
    
    private let coordinator: WeatherMapCoordinator
    private let repo: WeatherDataRepository
    private let locationService: LocationService
    
    private var subscriptions: Set<AnyCancellable> = []

    // TODO: Cache weather data
    @Published private(set) var weatherData: WeatherData?
    @Published private(set) var error: WeatherAPIError?
    
    init(coordinator: WeatherMapCoordinator,
         repo: WeatherDataRepository,
         locationService: LocationService) {
        self.coordinator = coordinator
        self.repo = repo
        self.locationService = locationService
        
        locationService.currentLocation
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { error in
                // handle error
            } receiveValue: { [weak self] location in
                self?.fetchWeatherData(with: location)
            }.store(in: &subscriptions )
    }
    
    func requestLocation() {
        locationService.getCurrentLocation()
    }
    
    func fetchWeatherData(with location: CLLocation?) {
        guard let lat = location?.coordinate.latitude,
              let lon = location?.coordinate.longitude else {
                  weatherData = nil
                  return
              }
        
        let params = ["lat": String(lat),
                      "lon": String(lon),
                      "exclude": "alerts,minutely,hourly"]
        
        repo.getWeatherData(with: params) { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .failure(let error):
                    self?.error = error
                case .success(let response):
                    self?.weatherData = response
                }
            }
        }
    }
    
    func cellTapped(indexPath: IndexPath) {
        guard indexPath.item < (weatherData?.daily?.count ?? 0),
              let data = weatherData?.daily?[indexPath.item] else {
                  return
              }
        coordinator.launchDetailsScreen(data: data)
    }
}
