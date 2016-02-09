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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var notificationCaseSegmented: UISegmentedControl!
    
    var currentAdApp: AdApp?
    var appsArray = [AdApp]()
    var timer: NSTimer?
    var finishTimer: NSTimer?
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.alwaysBounceVertical = true
        
        let params = ["id":"d016c31d-0778-488e-bf8c-4fdb8ddde8e0", "cnt":"200", "type":"json"]
        API.getApps(params).responseJSON { (response) -> Void in
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
                if let apps = json["apps"].array {
                    for app in apps {
                        self.appsArray.append(AdApp(json: app))
                    }
                    
                    self.collectionView.reloadData()
                }
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func checkNewFreeSpace() {
        print("checking...")
        let initFreeSpace = initialFreeSpace() ?? 0
        let currentFreeSpace = DeviceUtil().deviceRemainingFreeSpaceInBytes() ?? 0
        
        let difference = initFreeSpace - currentFreeSpace
        
        let notifCase = notificationCaseSegmented.selectedSegmentIndex
        let appSize = DeviceUtil.appSizeToBytes(currentAdApp!.appSize!) * ((notifCase == 1) ? 0.5 : (notifCase == 2) ? 0.33 : 1.0)
        
        if difference >= appSize {
            print("Assume app was downloaded")
            stopScanning()
            showNotification()
        }
    }
    
    func stopScanning() {
        timer?.invalidate()
        finishTimer?.invalidate()
    }
    
    private func showNotification() {
        let notification = UILocalNotification()
        notification.alertAction = currentAdApp?.title
        notification.alertBody = "Assume app was downloaded"
        notification.fireDate = nil
        notification.soundName = UILocalNotificationDefaultSoundName
        
        print("presenting local notification")
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
    private func saveInitialFreeSpace() {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(NSNumber(double:DeviceUtil().deviceRemainingFreeSpaceInBytes()!), forKey: "initialFreeSpace")
        ud.synchronize()
        
        backgroundTaskIdentifier = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
            UIApplication.sharedApplication().endBackgroundTask(self.backgroundTaskIdentifier!)
        }
        
        stopScanning()
        
        timer = NSTimer(timeInterval: 5.0, target: self, selector: "checkNewFreeSpace", userInfo: nil, repeats: true)
        finishTimer = NSTimer(timeInterval: 200.0, target: self, selector: "stopScanning", userInfo: nil, repeats: false)
        
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSDefaultRunLoopMode)
        NSRunLoop.mainRunLoop().addTimer(finishTimer!, forMode: NSDefaultRunLoopMode)
    }
    
    private func initialFreeSpace() -> Double? {
        let ud = NSUserDefaults.standardUserDefaults()
        let freeSpaceNumber = ud.objectForKey("initialFreeSpace") as? NSNumber
        
        return freeSpaceNumber?.doubleValue
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "openWebScreen") {
            let navigationController = segue.destinationViewController as? UINavigationController
            let webViewController = navigationController?.viewControllers[0] as? WebViewController
            webViewController?.openURL = currentAdApp?.appURL
            saveInitialFreeSpace()
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appsArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCellWithReuseIdentifier("adCollectionViewCell", forIndexPath: indexPath) as? AdCollectionViewCell
        let adApp = appsArray[indexPath.row]
        
        API.imageFromURL(adApp.imageURL ?? "").response { (_, _, data, _) -> Void in
            item?.iconImageView.image = UIImage(data: data!, scale: 1)
        }
        
        item?.titleLabel.text = adApp.title
        item?.appSizeLabel.text = "Size: \(adApp.appSize!)"
        
        return item!
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        currentAdApp = appsArray[indexPath.row]
        
        performSegueWithIdentifier("openWebScreen", sender: nil)
    }
}