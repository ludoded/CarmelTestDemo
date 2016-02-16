//
//  WebViewController.swift
//  AdSDKCarmel
//
//  Created by Aik Ampardjian on 08.02.16.
//  Copyright © 2016 Ayk. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    var openURL: String?
    var delegate: AdSDKDelegate?
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        let request = NSURLRequest(URL: NSURL(string: openURL ?? "")!)
        webView.loadRequest(request)
    }
}

extension WebViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print("fail")
        delegate?.saveInitialFreeSpace()
    }
}