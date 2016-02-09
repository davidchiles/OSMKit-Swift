//
//  OSMParseOperation.swift
//  OSMKit
//
//  Created by David Chiles on 12/21/15.
//  Copyright © 2015 David Chiles. All rights reserved.
//

import Foundation


internal class OSMParseOperation:NSOperation {
    
    var type:OSMElementType?
    var attributes:[String:String]?
    var tagAttributes:[[String:String]] = {
        return [[String:String]]()
    }()
    lazy var wayNodeAttributes:[[String:String]] = {
        return [[String:String]]()
    }()
    lazy var relationMemberAttributes:[[String:String]] = {
        return [[String:String]]()
    }()
    let completion:(element:OSMElement) -> Void
    
    init(completion:(element:OSMElement) -> Void) {
        self.completion = completion
    }
    
    func add(elementName:XMLName,attributes:[String:String]) {
        switch elementName {
        case .Node:
            self.type = .Node
            self.attributes = attributes
        case .Way:
            self.type = .Way
            self.attributes = attributes
        case .Relation:
            self.type = .Relation
            self.attributes = attributes
        case .Tag:
            self.tagAttributes.append(attributes)
        case .WayNode:
            self.wayNodeAttributes.append(attributes)
        case .Member:
            self.relationMemberAttributes.append(attributes)
        }
    }
    
    override func main() {
        //Make sure this element has a type
        guard let type = self.type else {
            return
        }
        
        //Make sure this element has basic attributes
        guard let attributes = self.attributes else {
            return
        }
        
        //Create Element
        let element = OSMParseOperation.element(type, attributes: attributes)
        
        
        //Go through all the tag attributes
        for var attributeDict in self.tagAttributes {
            guard let key = attributeDict[XMLAttributes.Key.rawValue] else {
                break
            }
            guard let value = attributeDict[XMLAttributes.Value.rawValue] else {
                break
            }
            
            element.addTag(key, value: value)
        }
        
        
        //Get all the nodes for a way
        for var attributeDict in self.wayNodeAttributes {
            guard let ndString = attributeDict[XMLAttributes.Ref.rawValue] else {
                break
            }
            
            guard let nd = Int64(ndString) else {
                break
            }
            
            (element as? OSMWay)?.nodes.append(nd)
        }
        
        //Relation Members
        for var attributeDict in self.relationMemberAttributes {
            guard let typeString = attributeDict[XMLAttributes.Typ.rawValue] else {
                break
            }
            
            guard let type = OSMElementType(rawValue: typeString) else {
                break
            }
            
            guard let refString = attributeDict[XMLAttributes.Ref.rawValue] else {
                break
            }
            
            guard let ref = Int64(refString) else {
                break
            }
            let member = OSMRelationMember(member: OSMID(type: type, ref: ref), role: attributeDict[XMLAttributes.Role.rawValue])
            (element as? OSMRelation)?.members.append(member)
        }
        
        completion(element: element)
    }
    
    class func element(type:OSMElementType,attributes:[String:String]) -> OSMElement {
        switch type {
        case .Node:
            return OSMNode(xmlAttributes: attributes)
        case .Way:
            return OSMWay(xmlAttributes: attributes)
        case .Relation:
            return OSMRelation(xmlAttributes: attributes)
        }
    }
}