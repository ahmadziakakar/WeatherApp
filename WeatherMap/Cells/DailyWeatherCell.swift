//
//  DailyWeatherCell.swift
//  WeatherMap
//
//  Created by Zia Kakar on 12/23/21.
//

import UIKit

class DailyWeatherCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImage.image = nil
        dateLabel.text = nil
        lowTempLabel.text = nil
        highTempLabel.text = nil
    }

    func configure(daily: DailyWeather) {
        if let url = iconImageURL(for: daily.weather.first?.icon) {
            iconImage.sd_setImage(with: url,
                                  placeholderImage: UIImage(named: "placeholder_avatar"))
        }

        dateLabel.text = "Date: \(daily.date)"
        lowTempLabel.text = "Low Temp: \(daily.temp.min)"
        highTempLabel.text = "High Temp: \(daily.temp.max)"
    }
    
    // TODO: Remove hard coded url string
    func iconImageURL(for iconName: String?) -> URL? {
        guard let name = iconName else { return nil }
        return URL(string: "https://openweathermap.org/img/wn/\(name)@2x.png")
    }
}
