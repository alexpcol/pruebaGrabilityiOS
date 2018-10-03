//
//  TVSerieData.swift
//  testRappi
//
//  Created by Mario on 10/1/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class TVSerieData: NSObject {
    
    var id: NSInteger?
    var name: String?
    var posterPath: String?
    var firstAirDate: String?
    var overview: String?
    
    override init() {}
    
    init(id: NSInteger?,
        name: String?,
         posterPath: String?,
         firstAirDate: String?,
         overview: String?)
    {
        self.id = id
        self.name = name
        self.posterPath = posterPath
        self.firstAirDate = firstAirDate
        self.overview = overview
    }

}
