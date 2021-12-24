//
//  RemoteWeatherService.swift
//  WeatherMap
//
//  Created by Zia Kakar on 12/23/21.
//

import Foundation

final class RemoteWeatherService: WeatherService {
    
    private let weatherMapAPIKey = "03a5e2a5617189c69879a7c69c3c6f0d"
    
    // TODO: create an enum for different endpoints
    private func weatherAPIURL(with param: [String: String]) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/onecall"
        components.queryItems = param.map { element in URLQueryItem(name: element.key, value: element.value)}
        components.queryItems?.append(URLQueryItem(name: "appid", value: weatherMapAPIKey))
        return components.url
    }

    func getWeatherData(with params: [String: String],
                        completion: @escaping (Result<WeatherData, WeatherAPIError>) -> Void) {
        guard let url = weatherAPIURL(with: params) else { return }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.transportError(error)))
            }
            
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(.failure(.serverError(statusCode: response.statusCode)))
                return
            }
            
            guard let jsonData = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let weatherMapResponse = try JSONDecoder().decode(WeatherData .self, from: jsonData)
                completion(.success(weatherMapResponse))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}

enum WeatherAPIError: Error {
    case transportError(Error)
    case serverError(statusCode: Int)
    case noData
    case decodingError(Error)
}
