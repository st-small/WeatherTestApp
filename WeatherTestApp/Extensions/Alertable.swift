//
//  Alertable.swift
//  WeatherTestApp
//
//  Created by Stanly Shiyanovskiy on 10.11.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

public enum AlertTitle: String {
    case wrongGPS = "Проблемы с получением координат!"
}

public enum AlertActionTitle: String {
    case ok = "OK"
    case cancel = "Отмена"
}

protocol Alertable {}

extension Alertable where Self: UIViewController {
    
    func showAlert(title: String, message: String, actionTitle: String) {
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle:. alert)
        let okAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alertView.addAction(okAction)
        present(alertView, animated: true, completion: nil)
    }
}

