//
//  WeatherMapCoordinator.swift
//  WeatherMap
//
//  Created by Zia Kakar on 12/23/21.
//

import Foundation
import UIKit

class WeatherMapCoordinator {
    
    var navigationController: UINavigationController?
    var repository: WeatherDataRepository

    init(_ navigationController: UINavigationController, repo: WeatherDataRepository) {
        self.navigationController = navigationController
        self.repository = repo
    }
    
    func start() {
        let viewModel = WeatherMapViewModel(coordinator: self, repo: repository, locationService: LocationService())
        let viewController = WeatherMapViewController.viewControllerFromStoryboard(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: false)
    }

    func launchDetailsScreen(data: DailyWeather) {
        let viewModel = WeatherDetailsViewModel(coordinator: self, data: data)
        let viewController = WeatherDetailsViewController.viewControllerFromStoryboard(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
