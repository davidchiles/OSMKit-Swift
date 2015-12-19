//
//  OSMNode.swift
//  Pods
//
//  Created by David Chiles on 12/11/15.
//
//

import Foundation
import CoreLocation

public class OSMNode: OSMElement {
    
    /** This node latitude. (WGS 84 - SRID 4326) */
    public var latitude:CLLocationDegrees = 0
    
    /** This node longitude. (WGS 84 - SRID 4326) */
    public var longitude:CLLocationDegrees = 0;
    
    override init(xmlAttributes: [String : String]) {
        super.init(xmlAttributes: xmlAttributes)
        guard let latString = xmlAttributes[XMLAttributes.Latitude.rawValue] else  {
            return
        }
        guard let lonString = xmlAttributes[XMLAttributes.Longitude.rawValue] else {
            return
        }
        guard let lat = Double(latString) else {
            return
        }
        guard let lon = Double(lonString) else {
            return
        }
        
        self.latitude = lat
        self.longitude = lon
    }
    
    public var coordinate:CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(self.latitude, self.longitude)
        }
    }

}
