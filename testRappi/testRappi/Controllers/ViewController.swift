//
//  ViewController.swift
//  testRappi
//
//  Created by chila on 10/1/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        let service = APIServices.init(delegate: self)
        service.getUpcomingMovies(language: nil, page: 1, region: nil)
    }

}

extension ViewController: ResponseServicesProtocol
{
    func onSucces(Result: String, name: ServicesNames) {
        print("success")
    }
    
    func onError(Error: String, name: ServicesNames) {
        print("Error")
    }
    
    
}

