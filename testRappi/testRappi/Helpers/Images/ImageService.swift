//
//  ImageService.swift
//  testRappi
//
//  Created by chila on 10/1/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class ImageService: NSObject {
    
    static let cache = NSCache<NSString, UIImage>()
    
    static func downloadImage(withURL url:URL, completion: @escaping (_ image:UIImage?)->()) {
         var downloadedImage:UIImage?
        let dataTask = URLSession.shared.dataTask(with: url) { data, responseURL, error in
           
            downloadedImage = nil
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            
            if let  downloadedimage = downloadedImage  {
                cache.setObject(downloadedimage, forKey: url.absoluteString as NSString)
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
        }
        dataTask.resume()
    }
    
    static func getImage(withURL urlString:String, completion: @escaping (_ image:UIImage?)->()) {
        let url = URL(string: urlString)
        if let image = cache.object(forKey: urlString as NSString) {
            completion(image)
        } else {
            downloadImage(withURL: url!, completion: completion)
        }
    }
}
