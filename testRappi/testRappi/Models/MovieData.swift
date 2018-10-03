//
//  MovieData.swift
//  testRappi
//
//  Created by Mario on 10/1/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class MovieData: NSObject {
    
    var id: NSInteger?
    var title: String?
    var posterPath: String?
    var releaseDate: String?
    var overview: String?
    
    override init() {}
    
    init(id: NSInteger?,
        title: String?,
         posterPath: String?,
         releaseDate: String?,
         overview: String?)
    {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.overview = overview
    }

}
