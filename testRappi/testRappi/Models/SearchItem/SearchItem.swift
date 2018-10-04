//
//  SearchItem.swift
//  testRappi
//
//  Created by Mario on 10/4/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class SearchItem: BaseItem {
    
    var mediaType: String?
    var date: String?
    var title: String? //This one will be used for movie and "name" for tvSerie
    
    init(mediaType: String?,
        id: NSInteger?,
         title: String?,
         posterPath: String?,
         date: String?,
         overview: String?)
    {
        super.init(id: id, posterPath: posterPath, overview: overview)
        
        self.mediaType = mediaType
        self.title = title
        self.date = date
    }
}
