//
//  AdApp.swift
//  AdSDKCarmel
//
//  Created by Aik Ampardjian on 08.02.16.
//  Copyright © 2016 Ayk. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AdApp {
    let title: String?
    let description: String?
    let imageURL: String?
    let imageWideURL: String?
    let appURL: String?
    let revenueType: String?
    let revenueRate: String?
    let categories: String?
    let idx: String?
    let iosPackage: String?
    let supportedDevices: String?
    let urlVideo: String?
    let urlVideoHigh: String?
    let urlVideo30Sec: String?
    let urlVideo30SecHigh: String?
    let bannerID: String?
    let campaignID: String?
    let country: String?
    let campaignType: String?
    let supportedVersion: String?
    let storeRating: String?
    let appSize: String?
    
    init(json: JSON) {
        title = json["title"].string
        description = json["desc"].string
        imageURL = json["urlImg"].string
        imageWideURL = json["urlImgWide"].string
        appURL = json["urlApp"].string
        revenueType = json["revenueType"].string
        revenueRate = json["revenueRate"].string
        categories = json["categories"].string
        idx = json["idx"].string
        iosPackage = json["iosPackage"].string
        supportedDevices = json["supportedDevices"].string
        urlVideo = json["urlVideo"].string
        urlVideoHigh = json["urlVideoHigh"].string
        urlVideo30Sec = json["urlVideo30Sec"].string
        urlVideo30SecHigh = json["urlVideo30SecHigh"].string
        bannerID = json["bannerId"].string
        campaignID = json["campaignId"].string
        country = json["country"].string
        campaignType = json["campaignType"].string
        supportedVersion = json["supportedVersion"].string
        storeRating = json["storeRating"].string
        appSize = json["appSize"].string
    }
}