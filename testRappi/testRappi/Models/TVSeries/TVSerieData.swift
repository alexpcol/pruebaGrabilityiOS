//
//  TVSerieData.swift
//  testRappi
//
//  Created by Mario on 10/1/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class TVSerieData: BaseItem {
    
    var name: String?
    var firstAirDate: String?
    
    
    init(id: NSInteger?,
        name: String?,
         posterPath: String?,
         firstAirDate: String?,
         overview: String?)
    {
        super.init(id: id, posterPath: posterPath, overview: overview)
        self.name = name
        self.firstAirDate = firstAirDate
    }

}
