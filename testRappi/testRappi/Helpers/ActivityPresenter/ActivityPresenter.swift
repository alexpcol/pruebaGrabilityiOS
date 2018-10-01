//
//  ActivityPresenter.swift
//  testRappi
//
//  Created by chila on 10/1/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class ActivityPresenter: NSObject {

    static func showActivityViewController(withActivityItems activityItems: [Any], andExcludedActivities excludedActivities: [UIActivity.ActivityType], inView view: UIViewController)
    {
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityController.excludedActivityTypes = excludedActivities
        view.present(activityController, animated: true, completion: nil)
    }
}
