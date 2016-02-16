//
//  DeviceUtil.swift
//  AdSDKCarmel
//
//  Created by Aik Ampardjian on 08.02.16.
//  Copyright © 2016 Ayk. All rights reserved.
//

import Foundation
import MachO

enum AppSizeType {
    case KB
    case MB
    case GB
}

class DeviceUtil {
    func deviceRemainingFreeSpaceInBytes() -> Double? {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var attributes: [String: AnyObject]
        do {
            attributes = try NSFileManager.defaultManager().attributesOfFileSystemForPath(documentDirectoryPath.last! as String)
            let freeSize = attributes[NSFileSystemFreeSize] as? NSNumber
            if (freeSize != nil) {
                let formatter = NSByteCountFormatter()
                formatter.allowedUnits = .UseMB
                formatter.countStyle = .Binary
                let freeBytes = formatter.stringFromByteCount(freeSize!.longLongValue)
                print("byte counts: \(freeBytes)")
                return freeSize?.doubleValue
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    static func appSizeToBytes(size: String) -> Double {
        let appSizeType = DeviceUtil.appSizeType(size)
        let appSize = atof(size)
        var multiplier: Int64 = 1
        
        switch appSizeType {
        case .KB:
            multiplier *= 1024
        case .MB:
            multiplier *= 1024 * 1024
        case .GB:
            multiplier *= 1024 * 1024 * 1024
        }
        
        let byteSize = appSize * Double(multiplier)
        let twentyFiveMB: Double = 25 * 1024 * 1024
        
        return byteSize > twentyFiveMB ? byteSize / 2 : byteSize
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