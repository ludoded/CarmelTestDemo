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
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = NSURLRequest(URL: NSURL(string: openURL ?? "")!)
        webView.loadRequest(request)
    }
}