//
//  RemoteWeatherMapRepository.swift
//  WeatherMap
//
//  Created by Zia Kakar on 12/23/21.
//

import Foundation
import CoreImage

class RemoteWeatherRepository: WeatherDataRepository {
    let service: WeatherService
    
    init(service: WeatherService) {
        self.service = service
    }

    func getWeatherData(with params: [String: String],
                        completion: @escaping (Result<WeatherData, WeatherAPIError>) -> Void) {
        service.getWeatherData(with: params, completion: completion)
    }
}
