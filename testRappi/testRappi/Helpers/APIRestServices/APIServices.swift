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
    
    //MARK: - Delegate Methods to VC
    func onSucces(Result : String, name : ServicesNames)
    {
        delegate?.onSucces(Result: Result, name: name);
    }
    
    func onError(Error : String, name : ServicesNames)
    {
        delegate?.onError(Error: Error, name: name);
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
        
        let serviceRequest = HttpMethods.init(delegate: self.delegate!, service: ServicesNames.GET_POPULAR_MOVIES)
        
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
        
        let serviceRequest = HttpMethods.init(delegate: self.delegate!, service: ServicesNames.GET_POPULAR_MOVIES)
        
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
        
        let serviceRequest = HttpMethods.init(delegate: self.delegate!, service: ServicesNames.GET_POPULAR_MOVIES)
        
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
        
        let serviceRequest = HttpMethods.init(delegate: self.delegate!, service: ServicesNames.GET_POPULAR_MOVIES)
        
        serviceRequest.RequestGETWithAutorization(URLString: url)
    }
    

}
