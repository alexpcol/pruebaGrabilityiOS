//
//  TVSeriesData.swift
//  testRappi
//
//  Created by Mario on 10/3/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class TVSeriesData: NSObject {
    var tvSeries: [TVSerieData]?
    
    override init() {}
    
    init(tvSeries: [TVSerieData]?)
    {
        self.tvSeries = tvSeries
    }
}
