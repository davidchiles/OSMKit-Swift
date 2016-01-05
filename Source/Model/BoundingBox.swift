//
//  BoundingBox.swift
//  Pods
//
//  Created by David Chiles on 12/21/15.
//
//

import Foundation
import CoreLocation

public struct BoundingBox {
    
    public var left:Double
    public var right:Double
    public var bottom:Double
    public var top:Double
    
    init(left:Double,right:Double,bottom:Double,top:Double) {
        self.left = left
        self.right = right
        self.bottom = bottom
        self.top = top
    }
    
}

public extension BoundingBox {
    public static func boundingBoxWithCorners(southWest:CLLocationCoordinate2D,northEast:CLLocationCoordinate2D) -> BoundingBox {
        let left = southWest.longitude;
        let bottom = southWest.latitude;
        let right = northEast.longitude;
        let top = northEast.latitude;
        return BoundingBox(left: left, right: right, bottom: bottom, top: top)
    }
}