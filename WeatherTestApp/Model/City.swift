//
//  City.swift
//  WeatherTestApp
//
//  Created by Stanly Shiyanovskiy on 09.11.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation

struct City {
    var name: String?
    var celsius: Double?
    var temperature: Int?
    var day: String?
    var description: String?
    var rain: String?
    var wind: String?
    var cloud: String?
    var long: Double?
    var lat: Double?
    
    // Inititalize
    init(name: String, temperature:Int, day: String, description: String, rain: String, wind: String, cloud: String) {
        
        self.name = name
        self.temperature = temperature
        self.day = day
        self.description = description
        self.rain = rain
        self.wind = wind
        self.cloud = cloud
    }
    
    init(longitude: Double, latitude: Double) {
        
        self.lat = latitude
        self.long = longitude
    }
}
