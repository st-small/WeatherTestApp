//
//  ViewController.swift
//  WeatherTestApp
//
//  Created by Stanly Shiyanovskiy on 09.11.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ViewModelDelegate, Alertable {
    
    // MARK: - Outlets -
    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var forecast: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    var model = ViewModel()
    var forecasts = [City]()
    var currentPosition: City!
    
    //city data
    var cloud:String?
    var rain:String?
    var wind:String?
    var citydatas = ["50", "0.03", "12"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        model.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // load weather data and set labels
        displayCityWeather()
        
    }
    
    func displayCityWeather() {
        loadWeatherData() { [weak self] (aArray) -> () in
            let day:Int = 0
            //fetch weather data
            DispatchQueue.main.async {
                //new array with cloudiness, rain volume and wind speed information
                self?.citydatas = aArray as! [String]
                //date change
                self?.date.text = (self?.forecasts[0].day)!
            }
            
            //(5-day weather forecast) - changeWeatherDataTo()
            delay(seconds: 5.0, completion: { () -> () in
                self?.changeWeatherDataTo(day)
                self?.animateTable()
            })
            //animate Table
            self?.animateTable()
        }
    }
    
    func loadWeatherData(completion: @escaping (_: NSArray) -> ()) {
        var newArray = [String]()
        // get current position
        model.getCurrentPosition { (city, response) in
            guard response == true else { showAlert(title: AlertTitle.wrongGPS.rawValue, message: "Проблемы с получением Вашей геопозиции. Проеверьте, разрешили ли Вы приложению получать данные о Вашем местоположении. Проверить это Вы можете в Настройках устройства", actionTitle: AlertActionTitle.ok.rawValue); return }
            // get weather data for current position
            APIService.getCityData(byCity: city!, completion: { [weak self] (array) in
                self?.forecasts = array
                DispatchQueue.main.async {
                    self?.cityName.text = self?.forecasts[0].name
                    self?.forecast.text = self?.forecasts[0].description
                    self?.tempLabel.text = "\((self?.forecasts[0].temperature)!)°"
                    
                    self?.cloud = self?.forecasts[0].cloud
                    self?.wind = self?.forecasts[0].wind
                    self?.rain = self?.forecasts[0].rain
                    
                    //new array with cloudiness, rain volume and wind speed information
                    newArray = [(self?.cloud)!, (self?.rain)!, (self?.wind)!]
                    completion(newArray as NSArray)
                    self?.tableView.reloadData()
                }
            })
        }
    }
    
    // MARK: - TableView -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citydatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! TableViewCell
        //configure cell
        cell.configure(citydatas[indexPath.row], index: indexPath.row)
        return cell
    }
    
    //animates tableView rows
    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        for a in cells {
            let cell: UITableViewCell = a
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
}

func delay(seconds: Double, completion:@escaping ()->()) {
    let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
    
    DispatchQueue.main.asyncAfter(deadline: popTime) {
        completion()
    }
}


