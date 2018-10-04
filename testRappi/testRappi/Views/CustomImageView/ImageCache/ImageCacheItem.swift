//
//  ImageCacheItem.swift
//  testRappi
//
//  Created by Mario on 10/4/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

open class ImageCacheItem: NSObject, NSDiscardableContent {
    //Generic method (trying to find the best way to set it) 🧐
    private(set) public var image: UIImage?
    var accessCount: UInt = 0
    
    public init(image: UIImage) {
        self.image = image
    }
    
    public func beginContentAccess() -> Bool {
        if image == nil {
            return false
        }
        
        accessCount += 1
        return true
    }
    
    public func endContentAccess() {
        if accessCount > 0 {
            accessCount -= 1
        }
    }
    
    public func discardContentIfPossible() {
        if accessCount == 0 {
            image = nil
        }
    }
    
    public func isContentDiscarded() -> Bool {
        return image == nil
    }
    
}
