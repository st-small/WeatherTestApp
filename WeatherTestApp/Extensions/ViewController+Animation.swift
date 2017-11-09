//
//  ViewController+Animation.swift
//  WeatherTestApp
//
//  Created by Stanly Shiyanovskiy on 09.11.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import UIKit

//use same direction
enum AnimationDirection: Int {
    case Positive = 1
    case Negative = -1
}

extension ViewController {
    
    func changeWeatherDataTo(_ day:Int, animated: Bool = true) {
        var day = day
        
        if animated {
            //random gradient background
            let imageView: String = randomBgView(cold: (self.forecasts[day].temperature)! > 20)
            
            fadeImageView(imageView: bgView,
                          toImage: UIImage(named: imageView)!)
            
            //weather info
            self.cityName.text = (self.forecasts[day].name)!
            self.forecast.text = self.forecasts[day].description
            self.tempLabel.text = "\((self.forecasts[0].temperature)!)°"
            
            //city datas
            self.cloud = self.forecasts[day].cloud
            self.wind = self.forecasts[day].wind
            self.rain = self.forecasts[day].rain
            
            if (day == forecasts.count-1) {
                day = 0
            } else {
                day += 1
            }
            
            self.citydatas = [self.cloud!,self.rain!, self.wind!]
            
            //animate day and forecast change
            daySwitchTo(self.forecasts[day].day!)
            forecastSwitchTo(self.forecasts[day].description!)
            
            //cubeTransition()
            self.cubeTransition(self.tempLabel, text: "\((self.forecasts[day].temperature)!)°", direction: .Positive)
        }
        
        //switch to next day
        delay(seconds: 5.0) {
            
            //changeWeatherDataTo()
            self.changeWeatherDataTo(day)
            self.animateTable()
        }
    }
    
    func cubeTransition(_ label: UILabel, text: String, direction: AnimationDirection) {
        
        let auxLabel = UILabel(frame: label.frame)
        auxLabel.text = text
        auxLabel.font = label.font
        auxLabel.textAlignment = label.textAlignment
        auxLabel.textColor = label.textColor
        auxLabel.backgroundColor = .clear
        
        let auxLabelOffset = CGFloat(direction.rawValue) *
            label.frame.size.height/2
        
        auxLabel.transform = CGAffineTransform(scaleX: 1.0, y: 0.1).concatenating(
            CGAffineTransform(translationX: 0.0, y: auxLabelOffset))
        
        label.superview!.addSubview(auxLabel)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
            
            auxLabel.transform = .identity
            label.transform = CGAffineTransform(scaleX: 1.0, y: 0.1).concatenating(
                CGAffineTransform(translationX: 0.0, y: -auxLabelOffset))
        }, completion: { _ in
            label.text = auxLabel.text
            label.transform = .identity
            auxLabel.removeFromSuperview()
        })
    }
    
    func daySwitchTo(_ date: String) {
        UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, options:[], animations: { [weak self] in
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.80, animations: { [weak self] in
                self?.date.alpha = 0.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.80, relativeDuration: 0.01, animations: { [weak self] in
                self?.date.alpha = 1.0
            })
        }, completion: nil)
        
        delay(seconds: 0.5, completion: { [weak self] in
            //switching date
            self?.date.text = date
        })
    }
    
    func forecastSwitchTo(_ forecast: String) {
        
        UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, options: [], animations: { [weak self] in
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.80, animations: { [weak self] in
                self?.forecast.alpha = 0.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.60, relativeDuration: 0.01, animations: { [weak self] in
                self?.forecast.alpha = 1.0
            })
        }, completion: nil)
        
        delay(seconds: 0.5, completion: { [weak self] in
            //switching forecast
            self?.forecast.text = forecast
        })
    }
    
    func fadeImageView(imageView: UIImageView, toImage: UIImage) {
        
        UIView.transition(with: imageView, duration: 1.0,
                          options: .transitionCrossDissolve, animations: {
                                    imageView.image = toImage
        }, completion: nil)
    }
    
    // background changing
    func randomBgView(cold:Bool) -> (String) {
        
        var index:Int = 0
        var gradient:String?
        
        let coldGradient = ["Gradient","Gradient1","Gradient2", "Gradient3" ]
        let hotGradient = ["Gradient4","Gradient5","Gradient6"]
        
        if (!cold) {
            index =  Int(arc4random_uniform(UInt32(coldGradient.count)))
            gradient = coldGradient[index] as String
            
        } else {
            index =  Int(arc4random_uniform(UInt32(hotGradient.count)))
            gradient =  hotGradient[index] as String
        }
        
        return gradient!
    }
}
