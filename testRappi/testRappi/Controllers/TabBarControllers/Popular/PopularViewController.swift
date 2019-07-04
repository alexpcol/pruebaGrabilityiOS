//
//  ViewController.swift
//  testRappi
//
//  Created by chila on 10/1/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class PopularViewController: UIViewController {

    // MARK:- Variables
    @IBOutlet weak var tvSeriesContainerView: UIView!
    @IBOutlet weak var moviesContainerView: UIView!
    
    // MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK:- Action Methods
    @IBAction func segmentIndexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            moviesContainerView.isHidden = false
            tvSeriesContainerView.isHidden = true
            break
        case 1:
            moviesContainerView.isHidden = true
            tvSeriesContainerView.isHidden = false
            break
        default:
            break
        }
    }
}
