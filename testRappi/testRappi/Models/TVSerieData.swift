//
//  TVSerieData.swift
//  testRappi
//
//  Created by Mario on 10/1/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class TVSerieData: NSObject {
    
    var name: String?
    var posterPath: String?
    var firstAirDate: String?
    var overview: String?
    
    override init() {}
    
    init(name: String?,
         posterPath: String?,
         firstAirDate: String?,
         overview: String?)
    {
        self.name = name
        self.posterPath = posterPath
        self.firstAirDate = firstAirDate
        self.overview = overview
    }

}
