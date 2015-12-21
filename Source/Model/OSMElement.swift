//
//  OSMObject.swift
//  Pods
//
//  Created by David Chiles on 12/11/15.
//
//

import Foundation

public enum OSMElementType:String {
    case Node     = "node"
    case Way      = "way"
    case Relation = "relation"
}

public class OSMElement: OSMIdentifiable {
    public var osmIdentifier:Int64 = -1
    
    public var version:Int = 0
    public var changeset:Int64 = 0
    public var userIdentifier:Int64 = 0
    public var username:String?
    public var visible:Bool = true
    
    public var tags:[String:String]?
    private var timestampString:String?
    public var timeStamp:NSDate? {
        get {
            if let timestamp = timestampString {
                return NSDateFormatter.defaultOpenStreetMapDateFormatter().dateFromString(timestamp)
            }
            return nil
        }
    }
    
    init(xmlAttributes:[String:String]) {
        
        //OSM id
        guard let idString = xmlAttributes[XMLAttributes.ID.rawValue] else {
            return
        }
        guard let id =  Int64(idString) else {
            return
        }
        
        //OSM version
        guard let versionString = xmlAttributes[XMLAttributes.Version.rawValue] else {
            return
        }
        guard let version = Int(versionString) else {
            return
        }
        
        //OSM changeset
        guard let changesetString = xmlAttributes[XMLAttributes.Changeset.rawValue] else {
            return
        }
        guard let changeset = Int64(changesetString) else {
            return
        }
        
        //OSM  userId
        guard let userIdentifierString = xmlAttributes[XMLAttributes.UID.rawValue] else {
            return
        }
        guard let userIdentifier = Int64(userIdentifierString) else {
            return
        }
        
        //OSM User
        guard let userString = xmlAttributes[XMLAttributes.User.rawValue] else {
            return
        }
        
        //OSM timestamp
        guard let timeStampString = xmlAttributes[XMLAttributes.Timestamp.rawValue] else {
            return
        }
        
        //OSM Visible
        guard let visibleString = xmlAttributes[XMLAttributes.Visible.rawValue] else {
            return
        }
        
        switch visibleString {
        case "true":
            self.visible = true
        case "false":
            self.visible = false
        default:
            break
        }
        
        
        self.osmIdentifier = id
        self.version = version
        self.changeset = changeset
        self.userIdentifier = userIdentifier
        self.username = userString
        self.timestampString = timeStampString
    }
    
    public func newTag(key:String,value:String) {
        if let _ = self.tags {
            self.tags![key] = value
        } else {
            self.tags = [String:String]()
            self.newTag(key, value: value)
        }
    }
}
