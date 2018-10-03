//
//  TopRatedViewController.swift
//  testRappi
//
//  Created by Mario on 10/2/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class TopRatedViewController: UIViewController {
    
    // MARK: - Variables
    
    @IBOutlet weak var moviesContainerView: UIView!
    @IBOutlet weak var tvSeriesContainerView: UIView!
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Action methods
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
