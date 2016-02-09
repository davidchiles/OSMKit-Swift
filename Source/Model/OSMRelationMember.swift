//
//  OSMRelationMember.swift
//  Pods
//
//  Created by David Chiles on 12/11/15.
//
//

import Foundation

public enum OSMID {
    case Node(Int64)
    case Way(Int64)
    case Relation(Int64)
    
    init(type:OSMElementType,ref:Int64) {
        switch type {
        case .Node: self = .Node(ref)
        case .Way: self = .Way(ref)
        case .Relation: self = .Relation(ref)
        }
    }
    
    func type() -> OSMElementType {
        switch self {
        case .Node(_): return .Node
        case .Way(_): return .Way
        case .Relation(_): return .Relation
        }
    }
    
    func ref() -> Int64 {
        switch self {
        case .Node(let ref): return ref
        case .Way(let ref): return ref
        case .Relation(let ref): return ref
        }
    }
}

public struct OSMRelationMember {
    public var member:OSMID
    public var role:String?
    
    init(member:OSMID, role:String?) {
        self.member = member
        self.role = role
    }
}
