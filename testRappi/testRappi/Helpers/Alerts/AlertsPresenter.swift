//
//  AlertsPresenter.swift
//  testRappi
//
//  Created by chila on 10/1/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class AlertsPresenter: NSObject {
    
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
