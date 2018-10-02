//
//  AlertsPresenter.swift
//  testRappi
//
//  Created by chila on 10/1/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class AlertsPresenter: NSObject {
    
    static func showOKAlert(title:String?, andMessage message:String?, inView view:UIViewController)
    {
        let okAction = UIAlertAction(title: "OK", style: .default) { (alert) in }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(okAction)
        view.present(alertController, animated: true, completion: nil)
    }
    
    static func showAlert(withActions actions:[UIAlertAction], title:String?, andMessage message:String?, inView view:UIViewController)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions
        {
            alertController.addAction(action)
        }
        view.present(alertController, animated: true, completion: nil)
    }
    
    static func showActionSheet(withActions actions:[UIAlertAction], title:String?, andMessage message:String?, inView view:UIViewController)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for action in actions
        {
            alertController.addAction(action)
        }
        view.present(alertController, animated: true, completion: nil)
    }
}
