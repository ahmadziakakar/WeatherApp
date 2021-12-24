//
//  MockWeatherService.swift
//  WeatherMap
//
//  Created by Zia Kakar on 12/23/21.
//

import Foundation

class MockWeatherService: WeatherDataRepository {
    func getWeatherData(with params: [String : String], completion: @escaping (Result<WeatherData, WeatherAPIError>) -> Void) {
        // TODO: Fetch mock response from a json file?
    }
}
