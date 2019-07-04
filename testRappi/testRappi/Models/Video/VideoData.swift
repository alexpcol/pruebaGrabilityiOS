//
//  VideoData.swift
//  testRappi
//
//  Created by chila on 10/3/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class VideoData: NSObject {
    var id: String?
    var key: String?
    var site: String?
    
    override init() {}
    
    init(id: String?,
         key: String?,
         site: String?) {
        self.id = id
        self.key = key
        self.site = site
    }
}
