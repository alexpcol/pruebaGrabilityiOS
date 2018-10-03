//
//  MovieCollectionViewCell.swift
//  testRappi
//
//  Created by Mario on 10/2/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        UIHelper.makeCardViewWithShadow(for: cardView)
        UIHelper.roundCorners(for: self)
        UIHelper.roundCorners(for: containerView)
    }

}
