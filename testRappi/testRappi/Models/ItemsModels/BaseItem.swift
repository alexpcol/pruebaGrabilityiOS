//
//  BaseItem.swift
//  testRappi
//
//  Created by Mario on 10/4/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class BaseItem {
    var id: NSInteger?
    var posterPath: String?
    var image: UIImage?
    var overview: String?
    
    init(id: NSInteger?, posterPath: String?, image: UIImage? ,overview: String?)
    {
        self.id = id
        self.posterPath = posterPath
        self.overview = overview
        self.image = image
    }
}
