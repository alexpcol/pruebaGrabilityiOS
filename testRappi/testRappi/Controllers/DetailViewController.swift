//
//  DetailViewController.swift
//  testRappi
//
//  Created by chila on 10/2/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - Variables
    var posterImage: UIImage?
    var titleString: String?
    var dateString: String?
    var overviewString: String?
    @IBOutlet weak var posterBackgroundImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var overViewTextView: UITextView!
    
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Configure Methods
    func configure()
    {
        configureViews()
        addRightNavigationItem()
    }
    // MARK: - navigation items Methods
    func addRightNavigationItem()
    {
        let playTrailerButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playTrailer))
        self.navigationItem.rightBarButtonItem  = playTrailerButton
    }
    @objc func playTrailer()
    {
        print("Play")
    }
    // MARK: - ConfigureViews Methods
    func configureViews()
    {
        posterBackgroundImageView.image = posterImage
        posterImageView.image = posterImage
        titleLabel.text = titleString
        dateLabel.text = dateString
        overViewTextView.text = overviewString
        self.view.bringSubviewToFront(overViewTextView)
        UIHelper.roundCorners(for: posterImageView)
    }
    
    

}
