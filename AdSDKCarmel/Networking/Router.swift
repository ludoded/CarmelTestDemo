//
//  Router.swift
//  AdSDKCarmel
//
//  Created by Aik Ampardjian on 08.02.16.
//  Copyright © 2016 Ayk. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    static let baseURLString = "https://admin.appnext.com"
    
    case Apps([String:String])
    
    var method: Alamofire.Method {
        switch self {
        case .Apps:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .Apps:
            return "/offerWallApi.aspx"
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        switch self {
        case .Apps(let params):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
        }
    }
}
