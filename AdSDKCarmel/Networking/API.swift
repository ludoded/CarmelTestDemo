//
//  API.swift
//  AdSDKCarmel
//
//  Created by Aik Ampardjian on 08.02.16.
//  Copyright © 2016 Ayk. All rights reserved.
//

import Foundation
import Alamofire

class API {
    static func getApps(params: [String:String]) -> Request {
        return Alamofire.request(Router.Apps(params))
    }
    
    static func imageFromURL(URL: String) -> Request {
        return Alamofire.request(.GET, URL)
    }
}