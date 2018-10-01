//
//  HttpMethods.swift
//  testRappi
//
//  Created by chila on 10/1/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration


//MARK:- Protocol to catch the answer
protocol ResponseServicesProtocol: class
{
    func onSucces(Result : String, name : ServicesNames)
    
    func onError(Error : String, name : ServicesNames)
}


class HttpMethods: NSObject {
    //MARK:- Properties
    weak var delegate : ResponseServicesProtocol?
    var currentService : ServicesNames?
    var timer : Timer?
    var requestDone = false
    var seconds : Int?
    
    //MARK:- Inits
    override init()
    {
        super.init()
    }
    
    init(delegate: ResponseServicesProtocol, service : ServicesNames)
    {
        self.delegate = delegate;
        self.currentService = service
        super.init()
    }
    
    //MARK:- Auxiliary Methods
    func hasInternet() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func notInternetAlert()
    {
        self.delegate?.onError(Error: "No Internet connection", name : .NO_INTERNET)
        return
    }
    
    
    
    //MARK:- Timer Methods
    /*
     Just if we need to tell the user that the Internet is bad
     */
    func requestTimer()
    {
        requestDone = false
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(1.0), target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @objc func countDown()
    {
        if timer == nil
        {
            return
        }
        
        if seconds == nil
        {
            seconds = -1
        }
        
        seconds = seconds! + 1
        print("Request time: " + String(describing: seconds))
        
        
        if requestDone == true
        {
            timer?.invalidate()
            timer = nil
            seconds = nil
        }
    }
    
    //MARK:- GET Method
    func RequestGET(URLString : String)
    {
        print("\n")
        print("Request(GET) " + URLString);
        var Request = URLRequest(url: URL(string: URLString)!)
        Request.httpMethod = "GET"
        if hasInternet()
        {
            //requestTimer()
            ExecuteTask(Request: Request)
        }
        else {
            notInternetAlert()
        }
    }
    
    //MARK:- GET Method with Auth
    func RequestGETWithAutorization(URLString : String)
    {
        print("\n")
        print("Request(GET) " + URLString);
        
        var Request = URLRequest(url: URL(string: URLString)!)
        Request.httpMethod = "GET"
        
        let token : String? = APIKeys.apiTokenV4.rawValue
        if token == nil
        {
            return
        }
        
        Request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Request.setValue("Bearer " + token!, forHTTPHeaderField: "Authorization")
        
        let postString : String? = "";
        
        Request.httpBody = postString?.data(using: .utf8)
        
        if hasInternet()
        {
            requestTimer()
            ExecuteTask(Request: Request)
        }
        else {
            notInternetAlert()
        }
        
    }
    
}



//MARK:- Request in Action
extension HttpMethods
{
    func ExecuteTask(Request : URLRequest)
    {
        let task = URLSession.shared.dataTask(with: Request) { data, response, error in
            guard let data = data, error == nil else
            {
                self.requestDone = true
                print("FATAL Error")
                self.delegate?.onError(Error: "Sorry! an error occurred in the system, please try again later", name : self.currentService!)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 404
            {
                self.requestDone = true
                print("OnSuccess with error")
                let responseString = String(data: data, encoding: .utf8)
                print("Result:\n \(String(describing: responseString!))")
                
                self.delegate?.onError(Error: "Error 404: Resource not found", name : self.currentService!)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 400
            {
                self.requestDone = true
                print("OnSuccess with error")
                let responseString = String(data: data, encoding: .utf8)
                print("Result:\n \(String(describing: responseString!))")
                
                self.delegate?.onError(Error: "Error 400: Bad request", name : self.currentService!)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
            {
                self.requestDone = true
                print("Something went terribly wrong")
                let responseString = String(data: data, encoding: .utf8)
                print("Result:\n \(String(describing: responseString!))")
                
                self.delegate?.onError(Error: "Error: Something went terribly wrong", name : self.currentService!)
                return
            }
            else
            {
                //OnSuccess
                self.requestDone = true
                print("200: OK")
                let responseString = String(data: data, encoding: .utf8)
                print("Result:\n \(String(describing: responseString!))")
                self.delegate?.onSucces(Result: String(describing: responseString!), name : self.currentService!)
                
            }
        }
        
        task.resume()
    }
    
}

