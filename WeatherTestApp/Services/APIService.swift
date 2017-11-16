//
//  APIService.swift
//  WeatherTestApp
//
//  Created by Stanly Shiyanovskiy on 09.11.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation

var apiKey = "6711862b8abe53f9"

class APIService {
    
    static func getCityData(byCity: City, completion: @escaping (_ array: [City]) -> ()) {
        
        let url = NSURL(string: "http://api.wunderground.com/api/\(apiKey)/forecast10day/lang:RU/q/\(byCity.lat!),\(byCity.long!).json")!
        
        URLSession.shared.dataTask(with: url as URL, completionHandler: { ( data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            
            do {
                let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                let forecasts = jsonDictionary["forecast"] as! [String:Any]
                let datas =  forecasts["simpleforecast"] as! [String:Any]
                let forecastsDays = datas["forecastday"] as! [[String:AnyObject]]
                
                var array = [City]()
                
                for day in forecastsDays {
                    
                    let countryAndCityStr = day["date"]!["tz_long"] as! String
                    let arr = countryAndCityStr.components(separatedBy: "/")
                    let cityName = byCity.name
                    
                    let desc = day["conditions"] as! String
                    
                    var tempMax = day["high"]!["celsius"] as! String
                    let tempMin = day["low"]!["celsius"] as! String
                    if tempMax == "" { tempMax = tempMin }
                    let temp = (Int(tempMax)! + Int(tempMin)!)/2
                    
                    let clouds = "\(day["pop"] as! Int)"
                    
                    let wind = "\(day["avewind"]!["kph"] as! Int)"
                    
                    let rain = "\(day["qpf_allday"]!["in"] as! Double)"
                    
                    let date = "\(day["date"]!["weekday"] as! String), \(day["date"]!["day"] as! Int) \(day["date"]!["monthname_short"] as! String)"
                    
                    let city = City(name: cityName!, temperature: temp, day: date, description: desc.capitalized, rain: rain, wind: wind, cloud: clouds)
                    
                    array.append(city)
                    
                }
                    DispatchQueue.main.async {
                        completion(array)
                    }
                
            } catch {
                print("invalid json query")
            }
            
        }).resume()
        
    }
}
