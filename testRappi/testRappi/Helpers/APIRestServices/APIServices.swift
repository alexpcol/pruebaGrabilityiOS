//
//  APIServices.swift
//  testRappi
//
//  Created by chila on 10/1/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class APIServices: NSObject {
    
    //URL Prod
    static let URLService : String = ""
    
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

}
