//
//  WeatherDetailsViewController.swift
//  WeatherMap
//
//  Created by Zia Kakar on 12/23/21.
//

import UIKit

class WeatherDetailsViewController: UIViewController {

    // TODO: make this a protocol with default implementation to avoid duplication
    class func viewControllerFromStoryboard(viewModel: WeatherDetailsViewModel) -> WeatherDetailsViewController {
        let viewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: String(describing: self)) as! WeatherDetailsViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    private var viewModel: WeatherDetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Details"
        descriptionLabel.text = viewModel.description
    }

}
