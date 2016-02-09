//
//  OSMNote.swift
//  Pods
//
//  Created by David Chiles on 1/5/16.
//
//

import Foundation
import CoreLocation

public struct OSMComment {
    public var userId:Int64?
    public var username:String?
    public var dateString:String
    public var text:String?
    public var action:OSMCommentAction
    
    public init(dateString:String, action:OSMCommentAction) {
        self.dateString = dateString
        self.action = action
    }
}

public class OSMNote: OSMIdentifiable {
    public var osmIdentifier:Int64 = -1
    
    /** This node latitude. (WGS 84 - SRID 4326) */
    public var latitude:CLLocationDegrees = 0
    
    /** This node longitude. (WGS 84 - SRID 4326) */
    public var longitude:CLLocationDegrees = 0;
    
    public var open = true
    
    public var url:NSURL? = nil
    
    public var comments:[OSMComment]?
    
    public var dateCreated:String
    public var dateClosed:String?
    
    public init(osmIdentifier:Int64, latitude:CLLocationDegrees, longitude:CLLocationDegrees, open:Bool, dateCreated:String, dateClosed:String?, url:NSURL?) {
        self.osmIdentifier = osmIdentifier
        self.latitude = latitude
        self.longitude = longitude
        self.open = open
        self.dateCreated = dateCreated
        self.dateClosed = dateClosed
        self.url = url
    }
}