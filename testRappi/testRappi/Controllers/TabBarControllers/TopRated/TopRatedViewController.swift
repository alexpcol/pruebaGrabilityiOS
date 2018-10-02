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
    
    @IBOutlet weak var moviesCollectionView: UIView!
    @IBOutlet weak var tvSeriesCollectionView: UIView!
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Action methods
    @IBAction func segmentIndexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            moviesCollectionView.isHidden = false
            tvSeriesCollectionView.isHidden = true
            break
        case 1:
            moviesCollectionView.isHidden = true
            tvSeriesCollectionView.isHidden = false
            break
        default:
            break
        }
    }

}
