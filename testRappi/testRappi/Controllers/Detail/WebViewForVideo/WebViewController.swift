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
    var videoKey: String!
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWeb()
    }
    func configureWeb() {
        webView.load(URLRequest(url: getURLVideo()))
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if webView.estimatedProgress == 1.0 {
                navigationItem.title = webView.title
            }
            else {
                navigationItem.title = "Loading..."
            }
        }
    }
    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    func getURLVideo() -> URL {
        let url = URL(string: URLS.youtubeURL.rawValue + videoKey)
        return url!
    }


}
