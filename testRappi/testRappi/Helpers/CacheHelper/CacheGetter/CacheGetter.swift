//
//  CacheGetter.swift
//  testRappi
//
//  Created by Mario on 10/3/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class CacheGetter: CacheBase {
    
    static func getPopularMovies(completion: @escaping (_ movies: MoviesData?)->())
    {
        print(CacheKeys.popularMovies.rawValue as NSString)
        if let movies: MoviesData = cacheForMovies.object(forKey: CacheKeys.popularMovies.rawValue as NSString)
        {
            completion(movies)
        }
        else
        {
            completion(nil)
        }
    }
    
    static func getTopRatedMovies(completion: @escaping (_ movies: MoviesData?)->())
    {
        if let movies = cacheForMovies.object(forKey: CacheKeys.topRatedMovies.rawValue as NSString)
        {
            completion(movies)
        }
        else
        {
            completion(nil)
        }
    }
    
    static func getUpcomingMovies(completion: @escaping (_ movies: MoviesData?)->())
    {
        if let movies = cacheForMovies.object(forKey: CacheKeys.upcomingMovies.rawValue as NSString)
        {
            completion(movies)
        }
        else
        {
            completion(nil)
        }
    }
    
    
    static func getPopularTVSeries(completion: @escaping (_ tvSeries: TVSeriesData?)->())
    {
        if let tvSeries = cacheForTVSeries.object(forKey: CacheKeys.popularTVSeries.rawValue as NSString)
        {
            completion(tvSeries)
        }
        else
        {
            completion(nil)
        }
    }
    
    static func getTopRatedTVSeries(completion: @escaping (_ tvSeries: TVSeriesData?)->())
    {
        if let tvSeries = cacheForTVSeries.object(forKey: CacheKeys.topRatedTVSeries.rawValue as NSString)
        {
            completion(tvSeries)
        }
        else
        {
            completion(nil)
        }
    }
    

}
