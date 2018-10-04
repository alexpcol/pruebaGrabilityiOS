//
//  DataTypeChanger.swift
//  testRappi
//
//  Created by chila on 10/1/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class DataTypeChanger: NSObject {

    static func JSONDataToDiccionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func DictionaryToJSONData(jsonObject: AnyObject) throws -> String?
    {
        let data: NSData? = try? JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
        
        var jsonStr: String?
        if data != nil {
            jsonStr = String(data: data! as Data, encoding: String.Encoding.utf8)
        }
        
        return jsonStr
    }
    
    static func CreateArrayOfSearch(results: [[String : Any]]) -> [SearchItem]
    {
        var arraySearch: [SearchItem] = []
        for result in results
        {
            var id = 0
            var mediaType = ""
            var title = ""
            var posterPath = ""
            var date = ""
            var overview = ""
            
            if let mediaTypeString = result["media_type"] as? String
            {
                if mediaTypeString == "tv" || mediaTypeString == "movie"
                {
                    mediaType = mediaTypeString
                    if let titleString = result["title"] as? String
                    {
                        title = titleString
                    }
                    else if let nameString = result["name"] as? String
                    {
                        title = nameString
                    }
                    
                    if let posterPathString = result["poster_path"] as? String
                    {
                        posterPath = posterPathString
                    }
                    
                    if let releaseDateString = result["release_date"] as? String
                    {
                        date = releaseDateString
                    }
                    else if let firstAirDateString = result["first_air_date"] as? String
                    {
                        date = firstAirDateString
                    }
                    
                    if let overviewString = result["overview"] as? String
                    {
                        overview = overviewString
                    }
                    
                    if let idInteger = result["id"] as? NSInteger
                    {
                        id = idInteger
                    }
                    arraySearch.append(SearchItem.init(mediaType: mediaType, id: id, title: title, posterPath: posterPath, date: date, overview: overview))
                }
            }
            
            
        }
        
        return arraySearch
    }
    
    
    static func CreateArrayOfMovies(results: [[String : Any]]) -> [MovieData]
    {
        var arrayMovies: [MovieData] = []
        for result in results
        {
            var id = 0
            var title = ""
            var posterPath = ""
            var releaseDate = ""
            var overview = ""
            
            if let titleString = result["title"] as? String
            {
                title = titleString
            }
            if let posterPathString = result["poster_path"] as? String
            {
                posterPath = posterPathString
            }
            
            if let releaseDateString = result["release_date"] as? String
            {
                releaseDate = releaseDateString
            }
            if let overviewString = result["overview"] as? String
            {
                overview = overviewString
            }
            
            if let idInteger = result["id"] as? NSInteger
            {
                id = idInteger
            }
            arrayMovies.append(MovieData.init(id: id,title: title, posterPath: posterPath, releaseDate: releaseDate, overview: overview))
        }
        
        return arrayMovies
    }
    
    static func CreateArrayOfTVSeries(results: [[String : Any]]) -> [TVSerieData]
    {
        var arrayTVSerie: [TVSerieData] = []
        for result in results
        {
            var id = 0
            var name = ""
            var posterPath = ""
            var firstAirDate = ""
            var overview = ""
            
            if let nameString = result["name"] as? String
            {
                name = nameString
            }
            if let posterPathString = result["poster_path"] as? String
            {
                posterPath = posterPathString
            }
            
            if let firstAirDateString = result["first_air_date"] as? String
            {
                firstAirDate = firstAirDateString
            }
            if let overviewString = result["overview"] as? String
            {
                overview = overviewString
            }
            if let idInteger = result["id"] as? NSInteger
            {
                id = idInteger
            }
            arrayTVSerie.append(TVSerieData.init(id: id,name: name, posterPath: posterPath, firstAirDate: firstAirDate, overview: overview))
        }
        
        return arrayTVSerie
    }
    
    static func CreateArrayOfVideos(results: [[String : Any]]) -> [VideoData]
    {
        var arrayVideos: [VideoData] = []
        for result in results
        {
            var id = ""
            var key = ""
            var site = ""
            
            if let idString = result["id"] as? String
            {
                id = idString
            }
            if let keyString = result["key"] as? String
            {
                key = keyString
            }
            
            if let siteString = result["site"] as? String
            {
                site = siteString
            }
            arrayVideos.append(VideoData.init(id: id, key: key, site: site))
        }
        
        return arrayVideos
    }
    
    
}
