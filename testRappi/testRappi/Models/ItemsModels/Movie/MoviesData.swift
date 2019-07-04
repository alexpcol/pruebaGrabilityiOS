//
//  MoviesData.swift
//  testRappi
//
//  Created by Mario on 10/3/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class MoviesData: NSObject {
    var movies: [MovieData]?
    
    override init() {}
    
    init(movies: [MovieData]?) {
        self.movies = movies
    }
    
}
