//
//  MovieData.swift
//  testRappi
//
//  Created by Mario on 10/1/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class MovieData: BaseItem {
    
    var title: String?
    var releaseDate: String?
    
    
    init(id: NSInteger?,
        title: String?,
         posterPath: String?,
         releaseDate: String?,
         overview: String?)
    {
        super.init(id: id, posterPath: posterPath, overview: overview)
        self.title = title
        self.releaseDate = releaseDate
    }
}
