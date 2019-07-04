//
//  CustomImageView.swift
//  testRappi
//
//  Created by Mario on 10/4/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {

   static let cache = NSCache<NSString,ImageCacheItem>()
    var shouldShowDefault = true
    
    var urlStringItem: String?
    var emptyImage: UIImage?
    
    func getImage(withURL urlString:String, completion: (() -> ())? = nil){
        image = nil
        self.urlStringItem = urlString
            guard let url = URL(string: urlString) else{
        if self.shouldShowDefault{ image = emptyImage}
                return
            }
            downloadImage(withURL: url, completion: completion)
    }
    
    func downloadImage(withURL url:URL, completion: (() -> ())? = nil)
    {
        let dataTask = URLSession.shared.dataTask(with: url) { data, responseURL, error in
            if error != nil{
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    let imageCache = ImageCacheItem(image: image)
                    CustomImageView.cache.setObject(imageCache, forKey: url.absoluteString as NSString)
                    if url.absoluteString == self.urlStringItem {
                        self.shouldShowDefault = false
                        DispatchQueue.main.async {
                            UIView.transition(with: self,
                                              duration:0.45,
                                              options: .transitionCrossDissolve,
                                              animations: {self.image = image },
                                              completion: nil)
                        }
                        completion?()
                    }
                }
            }
            
        }
        dataTask.resume()
    }
}
