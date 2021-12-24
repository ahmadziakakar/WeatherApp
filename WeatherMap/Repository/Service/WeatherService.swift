//
//  WeatherService.swift
//  WeatherMap
//
//  Created by Zia Kakar on 12/23/21.
//

import Foundation

protocol WeatherService {
    func getWeatherData(with params: [String: String],
                        completion: @escaping (Result<WeatherData, WeatherAPIError>) -> Void)
}
