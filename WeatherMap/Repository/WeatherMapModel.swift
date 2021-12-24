//
//  WeatherMapModel.swift
//  WeatherMap
//
//  Created by Zia Kakar on 12/23/21.
//

import Foundation

struct WeatherData: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: CurrentWeather
    let daily: [DailyWeather]?
    
    enum CodingKeys: String, CodingKey {
        case timezoneOffset = "timezone_offset"
        case lat, lon, timezone, current, daily
    }
}

struct CurrentWeather: Codable {
    let date: Int
    let weather: [Weather]
    let temp: Double

    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case weather, temp
    }
}

struct DailyWeather: Codable {
    let date: Int
    let weather: [Weather]
    let temp: Temp
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case weather, temp
    }
}

struct Weather: Codable {
    let id: Int
    let main: String?
    let description: String?
    let icon: String?
}

struct Temp: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}
