//
//  ViewModel.swift
//  WeatherTestApp
//
//  Created by Stanly Shiyanovskiy on 09.11.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import CoreLocation

protocol ViewModelDelegate {
    func displayCityWeather()
}

class ViewModel: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var delegate: ViewModelDelegate?
    
    func getCurrentPosition(completion: (_: City?, _ response: Bool) -> ()) {
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        if locationManager.location?.coordinate.longitude != nil, locationManager.location?.coordinate.latitude != nil {
            completion(
                City(longitude: (locationManager.location?.coordinate.longitude)!,
                     latitude: (locationManager.location?.coordinate.latitude)!), true)
        } else {
            completion(nil, false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _ = manager.location!.coordinate
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.displayCityWeather()
    }
}


