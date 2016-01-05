//
//  XMLEncoder.swift
//  Pods
//
//  Created by David Chiles on 12/21/15.
//
//

import Foundation
import AEXML

extension Dictionary where Key: StringLiteralConvertible, Value: StringLiteralConvertible {
    
    func xmlValue() -> [AEXMLElement] {
        var result = [AEXMLElement]()
        for (key,value) in self {
            let element = AEXMLElement()
            element.name = XMLName.Tag.rawValue
            element.attributes = [XMLAttributes.Key.rawValue:String(key),XMLAttributes.Value.rawValue:String(value)]
            result.append(element)
        }
        return result
    }
}

extension OSMRelationMember {
    func xmlValue() -> AEXMLElement {
        var attributes = [String:String]()
        attributes[XMLAttributes.Typ.rawValue] = self.type.rawValue
        attributes[XMLAttributes.Ref.rawValue] = String(self.reference)
        attributes[XMLAttributes.Role.rawValue] = self.role
        return AEXMLElement.init(XMLName.Member.rawValue, value: nil, attributes: attributes)
    }
}

public class OSMXML {
    class func xmlForElement(element:OSMElement) -> AEXMLElement? {
        let xmlElement = AEXMLElement()
        var name:XMLName? = nil
        var attributes:[String:String] = [String:String]()
        attributes[XMLAttributes.ID.rawValue] = String(element.osmIdentifier)
        attributes[XMLAttributes.UID.rawValue] = String(element.userIdentifier)
        attributes[XMLAttributes.User.rawValue] = element.username
        attributes[XMLAttributes.Version.rawValue] = String(element.version)
        attributes[XMLAttributes.Changeset.rawValue] = String(element.changeset)
        guard let timeStamp = element.timeStamp else {
            //throw
            return nil
        }
        let timeStampString = NSDateFormatter.defaultOpenStreetMapDateFormatter().stringFromDate(timeStamp)
        attributes[XMLAttributes.Timestamp.rawValue] = timeStampString
        switch element {
        case is OSMNode:
            attributes[XMLAttributes.Latitude.rawValue] = String((element as! OSMNode).latitude)
            attributes[XMLAttributes.Longitude.rawValue] = String((element as! OSMNode).longitude)
            name = .Node
        case is OSMWay:
            for nd in (element as! OSMWay).nodes {
                let nodeElement = AEXMLElement(XMLName.WayNode.rawValue)
                nodeElement.attributes = [XMLAttributes.Ref.rawValue:String(nd)]
                xmlElement.addChild(nodeElement)
            }
            name = .Way
        case is OSMRelation:
            for member in (element as! OSMRelation).members {
                xmlElement.addChild(member.xmlValue())
            }
            name = .Relation
        default:
            break
        }
        
        
        
        guard let nameValue = name?.rawValue else {
            //Throw error
            return nil
        }
        
        xmlElement.name = nameValue
        xmlElement.attributes = attributes
        
        
        if let tagElements = element.tags?.xmlValue() {
            for tag in tagElements {
                xmlElement.addChild(tag)
            }
        }
        
        return xmlElement
    }
}