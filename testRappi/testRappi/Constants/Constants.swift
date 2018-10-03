//
//  Constants.swift
//  testRappi
//
//  Created by Mario on 10/1/18.
//  Copyright © 2018 chila. All rights reserved.
//

import Foundation

enum APIKeys: String {
    case apiKeyV3 = "989c099296d06cf355d3b236e76c2ab0"
    case apiTokenV4 = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5ODljMDk5Mjk2ZDA2Y2YzNTVkM2IyMzZlNzZjMmFiMCIsInN1YiI6IjViYjI4MzhkYzNhMzY4MTQwYjAyM2YyZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.c69VpZcYj4IJZuIpPi60QGCrJ_O_EFkRbKYwyEC9cws"
}

// Im using v3 of the API because of this: https://www.themoviedb.org/talk/5af3e03f0e0a26397100627f?language=es
enum URLS: String {
    case apiURL = "https://api.themoviedb.org/3"
    case imageBaseURL = "http://image.tmdb.org/t/p/original"
    case secureImageBaseURL = "https://image.tmdb.org/t/p/original"
}


enum URLPaths: String {
    //MARK:- Popular Category
    case popularMovies = "/movie/popular"
    case popularTVSeries = "/tv/popular"
    
    //MARK:- Top Rated Category
    case topRatedMovies = "/movie/top_rated"
    case topRatedTVSeries = "/tv/top_rated"
    
    //MARK:- Upcoming Category
    case upcomingMovies = "/movie/upcoming"
}

enum QueryString: String {
    case apiKey = "?api_key="
    //MARK:- Movies & TV Serie Query
    case language = "&language="
    case page = "&page="
    case region = "&region="
}

enum CellsIdentifiers: String{
    case movieCollectionViewCell = "MovieCollectionViewCell"
    case refreshFooterView = "RefreshFooterView"
}

enum NibNames: String{
    case movieNib = "MovieCollectionViewCell"
    case loaderFooterNib = "LoaderFooterView"
}
