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
    case secureImageBaseURL = "https://image.tmdb.org/t/p/w500"
    case youtubeURL = "https://www.youtube.com/watch?v="
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
    
    //MARK:- Detail Category
    case movieDetail = "/movie/" //Add id
    case tvDetail = "/tv/"
    
    case searchItem = "/search/multi"
}

enum QueryString: String {
    case apiKey = "?api_key="
    //MARK:- Movies & TV Serie Query
    case language = "&language="
    case page = "&page="
    case region = "&region="
    
    case appendToResponse = "&append_to_response="
    case query = "&query="
}

enum CellsIdentifiers: String{
    case movieCollectionViewCell = "MovieCollectionViewCell"
    case refreshFooterView = "RefreshFooterView"
}

enum NibNames: String{
    case movieNib = "MovieCollectionViewCell"
    case loaderFooterNib = "LoaderFooterView"
}

enum CacheKeys: String{
    case popularMovies = "popularMoviesKey"
    case topRatedMovies = "topRatedMoviesKey"
    case upcomingMovies = "upcomingMoviesKey"
    
    case popularTVSeries = "popularTVSeriesKey"
    case topRatedTVSeries = "topRatedTVSeriesKey"
}

enum messagesText: String{
    case noVideos = "No videos founded"
    case noMoreResults = "There are no more results for this search"
}

enum messagesTitle: String{
    case sorry = "Sorry"
    case error = "Error"
    case ok = "OK"
}

enum ServicesFieldsKeys: String{
    case totalPages = "total_pages"
    case results = "results"
    case errors = "errors"
    case statusMessage = "status_message"
    case mediaType = "media_type"
    
    case title = "title"
    case name = "name"
    case posterPath = "poster_path"
    case firstAirDate = "first_air_date"
    case releadeDate = "release_date"
    case overview = "overview"
    case id = "id"
    case key = "key"
    case site = "site"
}

enum ViewControllerIdentifiers: String{
    case detailVC = "DetailViewController"
    case webVC = "WebViewController"
}

enum ErrorMessages: String{
    case noInternet = "No Internet connection"
    case sorryErrorSystem = "Sorry! an error occurred in the system, please try again later"
    case error404 = "Error 404: Resource not found"
    case error400 = "Error 400: Bad request"
}
