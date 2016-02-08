//
//  DeviceUtil.swift
//  AdSDKCarmel
//
//  Created by Aik Ampardjian on 08.02.16.
//  Copyright © 2016 Ayk. All rights reserved.
//

import Foundation

enum AppSizeType {
    case KB
    case MB
    case GB
}

class DeviceUtil {
    func deviceRemainingFreeSpaceInBytes() -> Int64? {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var attributes: [String: AnyObject]
        do {
            attributes = try NSFileManager.defaultManager().attributesOfFileSystemForPath(documentDirectoryPath.last! as String)
            let freeSize = attributes[NSFileSystemFreeSize] as? NSNumber
            if (freeSize != nil) {
                return freeSize?.longLongValue
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    static func appSizeToBytes(size: String) -> Int64 {
        let appSizeType = DeviceUtil.appSizeType(size)
        let appSize = atof(size)//NSNumberFormatter().numberFromString(size)?.doubleValue ?? 0
        var multiplier: Int64 = 1
        
        
        switch appSizeType {
        case .KB:
            multiplier *= 1024
        case .MB:
            multiplier *= 1024 * 1024
        case .GB:
            multiplier *= 1024 * 1024 * 1024
        }
        
        return Int64(appSize * Double(multiplier))
    }
    
    private static func appSizeType(size: String) -> AppSizeType {
        let lowerSize = size.lowercaseString
        
        if lowerSize.containsString("kb") {
            return .KB
        }
        else if lowerSize.containsString("mb") {
            return .MB
        }
        else {
            return .GB
        }
    }
}