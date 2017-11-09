//
//  TableViewCell.swift
//  WeatherTestApp
//
//  Created by Stanly Shiyanovskiy on 09.11.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    // weather titles
    let weatherInfoArray = ["облачность", "уровень осадков", "скорость ветра"]
    // weather icons for the tableView
    let icons = ["cloud_white", "rain_white", "windSpeed"]
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherInfo: UILabel!
    
    
    func configure(_ data: String, index: Int) {
        self.dataLabel.text = data
        self.weatherIcon.image = UIImage(named: icons[index])
        self.weatherInfo.text = weatherInfoArray[index]
        
        self.textLabel?.textColor = UIColor.white
        self.textLabel!.font = UIFont(name: "Verdana", size: 20)
    }
}
