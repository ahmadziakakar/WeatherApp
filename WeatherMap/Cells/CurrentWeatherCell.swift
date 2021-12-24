//
//  CurrentWeatherCell.swift
//  WeatherMap
//
//  Created by Zia Kakar on 12/23/21.
//

import UIKit

class CurrentWeatherCell: UICollectionViewCell {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImage.image = nil
        lowTempLabel.text = nil
        mainLabel.text = nil
    }

    func configure(current: CurrentWeather) {
        if let url = iconImageURL(for: current.weather.first?.icon) {
            iconImage.sd_setImage(with: url,
                                  placeholderImage: UIImage(named: "placeholder_avatar"))
        }

        lowTempLabel.text = "Current Temp \(current.temp)"
        mainLabel.text = current.weather.first?.main ?? ""
    }

    // TODO: Remove hard coded url string
    func iconImageURL(for iconName: String?) -> URL? {
        guard let name = iconName else { return nil }
        return URL(string: "https://openweathermap.org/img/wn/\(name)@2x.png")
    }

}
