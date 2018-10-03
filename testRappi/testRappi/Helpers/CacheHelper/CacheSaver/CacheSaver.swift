//
//  CacheSaver.swift
//  testRappi
//
//  Created by Mario on 10/3/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class CacheSaver: CacheBase {
    
    static func savePopularMovies(movies: [MovieData])
    {
        let moviesData = MoviesData.init(movies: movies)
        print(CacheKeys.popularMovies.rawValue as NSString)
        cacheForMovies.setObject(moviesData, forKey: CacheKeys.popularMovies.rawValue as NSString)
    }
    static func saveTopRatedMovies(movies: [MovieData])
    {
        let moviesData = MoviesData.init(movies: movies)
        cacheForMovies.setObject(moviesData, forKey: CacheKeys.topRatedMovies.rawValue as NSString)
    }
    
    static func saveUpcomingMovies(movies: [MovieData])
    {
        let moviesData = MoviesData.init(movies: movies)
        cacheForMovies.setObject(moviesData, forKey: CacheKeys.upcomingMovies.rawValue as NSString)
    }
    
    static func savePopularTVSeries(tvSeries: [TVSerieData])
    {
        let tvSeriesData = TVSeriesData.init(tvSeries: tvSeries)
        cacheForTVSeries.setObject(tvSeriesData, forKey: CacheKeys.popularTVSeries.rawValue as NSString)
    }
    
    static func saveTopRatedTVSeries(tvSeries: [TVSerieData])
    {
        let tvSeriesData = TVSeriesData.init(tvSeries: tvSeries)
        cacheForTVSeries.setObject(tvSeriesData, forKey: CacheKeys.topRatedTVSeries.rawValue as NSString)
    }
    
    
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
    
    
}
