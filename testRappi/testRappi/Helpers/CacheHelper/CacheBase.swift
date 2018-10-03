//
//  CacheBase.swift
//  testRappi
//
//  Created by Mario on 10/3/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class CacheBase: NSObject {
    
    static let cacheForMovies = NSCache<NSString, MoviesData>()
    static let cacheForTVSeries = NSCache<NSString, TVSeriesData>()
}
