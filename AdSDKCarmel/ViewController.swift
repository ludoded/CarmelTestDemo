//
//  ViewController.swift
//  AdSDKCarmel
//
//  Created by Aik Ampardjian on 08.02.16.
//  Copyright © 2016 Ayk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    @IBOutlet weak var adView: UIView!
    
    var currentAdApp: AdApp?
    var timer: NSTimer?
    var finishTimer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let params = ["id":"d016c31d-0778-488e-bf8c-4fdb8ddde8e0", "cnt":"200", "type":"json"]
        API.getApps(params).responseJSON { (response) -> Void in
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
                if let apps = json["apps"].array {
                    for app in apps {
                        self.setupAd(AdApp(json: app))
                        break
                    }
                }
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func setupAd(adApp: AdApp) {
        currentAdApp = adApp
        
        let imageView = UIImageView(frame: adView.bounds)
        imageView.contentMode = .ScaleAspectFit
        adView.addSubview(imageView)
        
        API.imageFromURL(adApp.imageWideURL ?? "").response { (_, _, data, _) -> Void in
            imageView.image = UIImage(data: data!, scale: 1)
        }
    }
    
    func checkNewFreeSpace() {
        let initFreeSpace = initialFreeSpace() ?? 0
        let currentFreeSpace = DeviceUtil().deviceRemainingFreeSpaceInBytes() ?? 0
        
        let difference = initFreeSpace - currentFreeSpace
        let appSize = DeviceUtil.appSizeToBytes(currentAdApp!.appSize!)
        
        if difference >= appSize {
            print("Assume app was downloaded")
            stopScanning()
        }
    }
    
    func stopScanning() {
        timer?.invalidate()
        finishTimer?.invalidate()
    }
    
    private func saveInitialFreeSpace() {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(NSNumber(longLong:DeviceUtil().deviceRemainingFreeSpaceInBytes()!), forKey: "initialFreeSpace")
        ud.synchronize()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "checkNewFreeSpace", userInfo: nil, repeats: true)
        finishTimer = NSTimer.scheduledTimerWithTimeInterval(600.0, target: self, selector: "stopScanning", userInfo: nil, repeats: false)
    }
    
    private func initialFreeSpace() -> Int64? {
        let ud = NSUserDefaults.standardUserDefaults()
        let freeSpaceNumber = ud.objectForKey("initialFreeSpace") as? NSNumber
        
        return freeSpaceNumber?.longLongValue
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "openWebScreen") {
            let navigationController = segue.destinationViewController as? UINavigationController
            let webViewController = navigationController?.viewControllers[0] as? WebViewController
            webViewController?.openURL = currentAdApp?.appURL
            saveInitialFreeSpace()
        }
    }
    
    @IBAction func openURL(sender: AnyObject) {
        if currentAdApp != nil {
            performSegueWithIdentifier("openWebScreen", sender: nil)
        }
    }
}