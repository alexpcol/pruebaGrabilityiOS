//
//  WebViewController.swift
//  testRappi
//
//  Created by chila on 10/3/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    
    // MARK: - Variables
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getVideo()
    }
    func getVideo()
    {
        let url = URL(string: "https://www.youtube.com/watch?v=SPHfeNgogVs")
        webView.load(URLRequest(url: url!))
    }


}
