//
//  LocationManager.swift
//  WeatherMap
//
//  Created by Zia Kakar on 12/23/21.
//

import Foundation
import CoreLocation
import Combine

class LocationService: NSObject, CLLocationManagerDelegate {
        
    private var locationManager: CLLocationManager

    let currentLocation = CurrentValueSubject<CLLocation?, Never>(nil)

    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyReduced
    }
    
    public func getCurrentLocation() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
            // TODO: handle different cases
        default:
            print("Location manager didChangeAuthorization \(status)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation.send(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        currentLocation.send(nil)
        print("locationManagerDidFailWithError \(error) ")
    }

}
