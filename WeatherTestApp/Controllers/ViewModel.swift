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
    var city = ""
    
    func getCurrentPosition(completion: @escaping (_: City?, _ response: Bool) -> ()) {
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        if ((locationManager.location?.coordinate) != nil) {
            let loc = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
            getCityName(location: loc, completion: { [weak self] in
                completion(City(longitude: (loc.coordinate.longitude),
                                latitude: (loc.coordinate.latitude), city: self?.city), true)
            })
        } else {
            completion(nil, false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _ = manager.location!.coordinate
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func getCityName(location: CLLocation, completion: @escaping () -> ()) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self]
            (placemarks, error) -> Void in
            if let placemarks = placemarks, placemarks.count > 0 {
                self?.city = placemarks[0].locality!
                completion()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.displayCityWeather()
    }
}


