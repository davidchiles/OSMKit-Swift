//
//  File.swift
//  OSMKit
//
//  Created by David Chiles on 12/17/15.
//  Copyright © 2015 David Chiles. All rights reserved.
//

import Foundation

var onceToken: dispatch_once_t = 0
var instance: NSDateFormatter? = nil

public extension NSDateFormatter {
    // 2x speed increate using singlton from onceToken vs creating a new nsdateformatter each time it's used
    public class func defaultOpenStreetMapDateFormatter() -> NSDateFormatter{
        dispatch_once(&onceToken) {
            instance = NSDateFormatter()
            instance?.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZ"
        }
        return instance!
    }
    
}