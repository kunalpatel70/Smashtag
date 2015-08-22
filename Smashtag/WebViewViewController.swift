//
//  WebViewViewController.swift
//  Smashtag
//
//  Created by Kunal Patel on 8/15/15.
//  Copyright (c) 2015 Kunal Patel. All rights reserved.
//

import UIKit

class WebViewViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var webURL: NSURL? {
        didSet {
            loadWebView()
        }
    }
    
    func loadWebView() {
        if let myWeView = webView {
            let reqeustObj = NSURLRequest(URL: webURL!)
            webView.loadRequest(reqeustObj)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
        //webView.delegate = self
        webView.scalesPageToFit = true
    }
    
}
