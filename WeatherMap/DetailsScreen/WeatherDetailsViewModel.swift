//
//  WeatherDetailsViewModel.swift
//  WeatherMap
//
//  Created by Zia Kakar on 12/23/21.
//

import Foundation

class WeatherDetailsViewModel {
    
    private let coordinator: WeatherMapCoordinator
    private let data: DailyWeather

    init(coordinator: WeatherMapCoordinator, data: DailyWeather) {
        self.coordinator = coordinator
        self.data = data
    }
    
    var description: String {
        data.weather.first?.description ?? ""
    }
}
