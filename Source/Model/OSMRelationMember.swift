//
//  OSMRelationMember.swift
//  Pods
//
//  Created by David Chiles on 12/11/15.
//
//

import Foundation

public struct OSMRelationMember {
    public var type:OSMElementType
    public var reference:Int64
    public var role:String?
    
    init(type:OSMElementType, reference:Int64, role:String?) {
        self.type = type
        self.reference = reference
        self.role = role
    }
}
