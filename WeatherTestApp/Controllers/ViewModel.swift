//
//  ViewModel.swift
//  WeatherTestApp
//
//  Created by Stanly Shiyanovskiy on 09.11.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import CoreLocation

class ViewModel: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    func getCurrentPosition(completion: (_: City) -> ()) {
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        completion(City(longitude: locationManager.location!.coordinate.longitude, latitude: locationManager.location!.coordinate.latitude))
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}


