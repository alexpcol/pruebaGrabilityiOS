//
//  MovieCollectionViewCell.swift
//  testRappi
//
//  Created by Mario on 10/2/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit
import Nuke

class MovieCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var posterImageView: CustomImageView!
    
    var pipeline = Nuke.ImagePipeline.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        UIHelper.makeCardViewWithShadow(for: cardView)
        UIHelper.roundCorners(for: self)
        UIHelper.roundCorners(for: containerView)
    }
    
    func configure(with data: MovieData){
        titleLabel.text = data.title
        guard let url = URL(string: URLS.secureImageBaseURL.rawValue + data.posterPath!) else{
            return
        }
        let request = makeRequest(with: url)
        DispatchQueue.main.async {
            var options = ImageLoadingOptions(transition: .fadeIn(duration: 0.25))
            options.pipeline = self.pipeline
            Nuke.loadImage(with: request, options: options, into: self.posterImageView)
        }
        
    }
    
    func makeRequest(with url: URL) -> ImageRequest {
        return ImageRequest(url: url)
    }

}
