//
//  WeatherMapViewController.swift
//  WeatherMap
//
//  Created by Zia Kakar on 12/23/21.
//

import UIKit
import Combine
import SDWebImage
import CoreLocation

class WeatherMapViewController: UIViewController {
    
    // TODO: make this a protocol with default implementation to avoid duplication
    class func viewControllerFromStoryboard(viewModel: WeatherMapViewModel) -> WeatherMapViewController {
        let viewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: String(describing: self)) as! WeatherMapViewController
        viewController.viewModel = viewModel
        return viewController
    }

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: WeatherMapViewModel!
    private var subscriptions: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Weather"
                        
        setupLayout()
        
        viewModel.$weatherData
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                self.collectionView.reloadData()
            })
            .store(in: &subscriptions)
        
        viewModel.$error
            .sink { [weak self] error in
                self?.activityIndicator.stopAnimating()
                self?.handleError(error: error)
            }
            .store(in: &subscriptions)
        
    }
        
    @IBAction func locationNavButtonTapped(_ sender: Any) {
        activityIndicator.startAnimating()
        viewModel.requestLocation()
    }
    
    // TODO: Make error messages user friendly
    private func handleError(error: WeatherAPIError?) {
        guard let apiError = error else { return }
        switch apiError {
        case .transportError(let error):
            showAlert(title: "Transport Error", message: error.localizedDescription)
        case .serverError(let statusCode):
            showAlert(title: "Error", message: "Server code error: \(statusCode)")
        case .noData:
            showAlert(title: "Error", message: "No Data found!")
        case .decodingError(let error):
            showAlert(title: "Decoding Error", message: error.localizedDescription)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupLayout() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 120)
        layout.estimatedItemSize = .zero
    }
}

extension WeatherMapViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        (viewModel.weatherData != nil) ? 2 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        (section == 0) ? 1 : (viewModel.weatherData?.daily?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: CurrentWeatherCell.self),
                for: indexPath) as? CurrentWeatherCell,
                  let currentWeatherData = viewModel.weatherData?.current else {
                return UICollectionViewCell()
            }
            cell.configure(current: currentWeatherData)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: DailyWeatherCell.self),
                for: indexPath) as? DailyWeatherCell,
                  let dailyWeatherData = viewModel.weatherData?.daily?[indexPath.row] else {
                return UICollectionViewCell()
            }
            cell.configure(daily: dailyWeatherData)
            return cell
        }
    }
}

extension WeatherMapViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        viewModel.cellTapped(indexPath: indexPath)
    }
}
