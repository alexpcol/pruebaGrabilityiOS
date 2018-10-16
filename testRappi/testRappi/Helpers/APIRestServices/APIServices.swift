//
//  APIServices.swift
//  testRappi
//
//  Created by chila on 10/1/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class APIServices: NSObject {
    
    weak var delegate : ResponseServicesProtocol?
    
    override init()
    {
        super.init()
    }
    
    init(delegate: ResponseServicesProtocol)
    {
        self.delegate = delegate;
        super.init()
    }
    
    //MARK: - APIMethods
    func getPopularMovies(language:String?, page: NSInteger, region: String?)
    {
        let urlRequest = URLS.apiURL.rawValue + URLPaths.popularMovies.rawValue
        
        let pageKey = QueryString.page.rawValue + String(page)
        let apiKey = QueryString.apiKey.rawValue + APIKeys.apiKeyV3.rawValue
        var languageKey = ""
        var regionKey = ""

        if let languageString = language
        {
            languageKey = QueryString.language.rawValue + languageString
        }
        if let regionString = region
        {
            regionKey = QueryString.region.rawValue + regionString
        }
        
        let url = urlRequest + apiKey + languageKey + pageKey + regionKey
        
        let serviceRequest = HttpMethods.init(delegate: self.delegate!, service: ServicesNames.GET_POPULAR_MOVIES)
        
        serviceRequest.RequestGETWithAutorization(URLString: url)
    }
    
    func getPopularTVSeries(language:String?, page: NSInteger, region: String?)
    {
        let urlRequest = URLS.apiURL.rawValue + URLPaths.popularTVSeries.rawValue
        
        let pageKey = QueryString.page.rawValue + String(page)
        let apiKey = QueryString.apiKey.rawValue + APIKeys.apiKeyV3.rawValue
        var languageKey = ""
        var regionKey = ""
        
        if let languageString = language
        {
            languageKey = QueryString.language.rawValue + languageString
        }
        if let regionString = region
        {
            regionKey = QueryString.region.rawValue + regionString
        }
        
        let url = urlRequest + apiKey + languageKey + pageKey + regionKey
        
        let serviceRequest = HttpMethods.init(delegate: self.delegate!, service: ServicesNames.GET_POPULAR_TV_SERIES)
        
        serviceRequest.RequestGETWithAutorization(URLString: url)
    }
    
    func getTopRatedMovies(language:String?, page: NSInteger, region: String?)
    {
        let urlRequest = URLS.apiURL.rawValue + URLPaths.topRatedMovies.rawValue
        
        let pageKey = QueryString.page.rawValue + String(page)
        let apiKey = QueryString.apiKey.rawValue + APIKeys.apiKeyV3.rawValue
        var languageKey = ""
        var regionKey = ""
        
        if let languageString = language
        {
            languageKey = QueryString.language.rawValue + languageString
        }
        if let regionString = region
        {
            regionKey = QueryString.region.rawValue + regionString
        }
        
        let url = urlRequest + apiKey + languageKey + pageKey + regionKey
        
        let serviceRequest = HttpMethods.init(delegate: self.delegate!, service: ServicesNames.GET_TOP_RATED_MOVIES)
        
        serviceRequest.RequestGETWithAutorization(URLString: url)
    }
    
    func getTopRatedTVSeries(language:String?, page: NSInteger, region: String?)
    {
        let urlRequest = URLS.apiURL.rawValue + URLPaths.topRatedTVSeries.rawValue
        
        let pageKey = QueryString.page.rawValue + String(page)
        let apiKey = QueryString.apiKey.rawValue + APIKeys.apiKeyV3.rawValue
        var languageKey = ""
        var regionKey = ""
        
        if let languageString = language
        {
            languageKey = QueryString.language.rawValue + languageString
        }
        if let regionString = region
        {
            regionKey = QueryString.region.rawValue + regionString
        }
        
        let url = urlRequest + apiKey + languageKey + pageKey + regionKey
        
        let serviceRequest = HttpMethods.init(delegate: self.delegate!, service: ServicesNames.GET_TOP_RATED_TV_SERIES)
        
        serviceRequest.RequestGETWithAutorization(URLString: url)
    }
    
    func getUpcomingMovies(language:String?, page: NSInteger, region: String?)
    {
        let urlRequest = URLS.apiURL.rawValue + URLPaths.upcomingMovies.rawValue
        
        let pageKey = QueryString.page.rawValue + String(page)
        let apiKey = QueryString.apiKey.rawValue + APIKeys.apiKeyV3.rawValue
        var languageKey = ""
        var regionKey = ""
        
        if let languageString = language
        {
            languageKey = QueryString.language.rawValue + languageString
        }
        if let regionString = region
        {
            regionKey = QueryString.region.rawValue + regionString
        }
        
        let url = urlRequest + apiKey + languageKey + pageKey + regionKey
        
        let serviceRequest = HttpMethods.init(delegate: self.delegate!, service: ServicesNames.GET_UPCOMING_MOVIES)
        
        serviceRequest.RequestGETWithAutorization(URLString: url)
    }
    
    func getMovieDetail(id: NSInteger, language:String?, appendToResponse: String?)
    {
        let urlRequest = URLS.apiURL.rawValue + URLPaths.movieDetail.rawValue + String(id)
        
        var appendToResponseKey = ""
        var languageKey = ""
        let apiKey = QueryString.apiKey.rawValue + APIKeys.apiKeyV3.rawValue
        if let appendToResponseString = appendToResponse
        {
            appendToResponseKey = QueryString.appendToResponse.rawValue + appendToResponseString
        }
        if let languageString = language
        {
            languageKey = QueryString.language.rawValue + languageString
        }
        
        let url = urlRequest + apiKey + languageKey + appendToResponseKey
        
        let serviceRequest = HttpMethods.init(delegate: self.delegate!, service: ServicesNames.GET_MOVIE_DETAIL)
        serviceRequest.RequestGETWithAutorization(URLString: url)
    }
    
    func getTvSerieDetail(id: NSInteger, language:String?, appendToResponse: String?)
    {
        let urlRequest = URLS.apiURL.rawValue + URLPaths.tvDetail.rawValue + String(id)
        
        var appendToResponseKey = ""
        var languageKey = ""
        let apiKey = QueryString.apiKey.rawValue + APIKeys.apiKeyV3.rawValue
        if let appendToResponseString = appendToResponse
        {
            appendToResponseKey = QueryString.appendToResponse.rawValue + appendToResponseString
        }
        if let languageString = language
        {
            languageKey = QueryString.language.rawValue + languageString
        }
        
        let url = urlRequest + apiKey + languageKey + appendToResponseKey
        
        let serviceRequest = HttpMethods.init(delegate: self.delegate!, service: ServicesNames.GET_TV_SERE_DETAIL)
        serviceRequest.RequestGETWithAutorization(URLString: url)
    }
    
    func getSearchItem(language:String?, page: NSInteger, region: String?, query:String)
    {
         let urlRequest = URLS.apiURL.rawValue + URLPaths.searchItem.rawValue
        
        let pageKey = QueryString.page.rawValue + String(page)
        let apiKey = QueryString.apiKey.rawValue + APIKeys.apiKeyV3.rawValue
        let queryKey = QueryString.query.rawValue + query
        var languageKey = ""
        var regionKey = ""
        
        if let languageString = language
        {
            languageKey = QueryString.language.rawValue + languageString
        }
        if let regionString = region
        {
            regionKey = QueryString.region.rawValue + regionString
        }
        
        let url = urlRequest + apiKey + queryKey + languageKey + pageKey + regionKey
        
        let serviceRequest = HttpMethods.init(delegate: self.delegate!, service: ServicesNames.GET_SEARCH_ITEM)
        
        serviceRequest.RequestGETWithAutorization(URLString: url)
    }

}
