//
//  OSMParser.swift
//  Pods
//
//  Created by David Chiles on 12/11/15.
//
//

import Foundation

public protocol OSMParserDelegate {
    func didStartParsing(parser:OSMParser)
    func didFinishParsing(parser:OSMParser)
    func didFindElement(parser:OSMParser,element:OSMElement)
    func didError(parser:OSMParser,error:ErrorType?)
}

public enum XMLName:String {
    case Node     = "node"
    case Way      = "way"
    case Relation = "relation"
    case Tag      = "tag"
    case WayNode  = "nd"
    case Member   = "member"
}

public enum XMLAttributes:String {
    case ID = "id"
    case UID = "uid"
    case User = "user"
    case Version = "version"
    case Changeset = "changeset"
    case Timestamp = "timestamp"
    case Visible = "visible"
    case Latitude = "lat"
    case Longitude = "lon"
    case Key      = "k"
    case Value    = "v"
    case Ref = "ref"
    case Role = "role"
    case Typ = "type"
}

public class OSMParser:NSObject,NSXMLParserDelegate {
    
    public var delegate:OSMParserDelegate?
    public var delegateQueue = dispatch_queue_create("OSMParserDelegateQueue", nil)
    
    private var currentElement:OSMElement?
    private var xmlParser:NSXMLParser
    
    private let workQueue = dispatch_queue_create("OSMParserWorkQueue", nil)
    
    init(data:NSData) {
        self.xmlParser = NSXMLParser(data: data)
    }
    
    init(stream:NSInputStream) {
        self.xmlParser = NSXMLParser(stream: stream)
        
    }
    
    public func parse() {
        self.xmlParser.delegate = self
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0),{[weak self] () -> Void in
            self?.xmlParser.parse()
        })
    }
    
    
    //MARK: NSXMLParserDelegate Methods
    
    @objc public func parserDidStartDocument(parser: NSXMLParser) {
        dispatch_async(self.workQueue) { () -> Void in
            dispatch_async(self.delegateQueue, { () -> Void in
                self.delegate?.didStartParsing(self)
            })
        }
    }
    
    @objc public func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        dispatch_async(self.workQueue) {[weak self] () -> Void in
            switch elementName {
            case XMLName.Tag.rawValue:
                guard let key = attributeDict[XMLAttributes.Key.rawValue] else {
                    break
                }
                guard let value = attributeDict[XMLAttributes.Value.rawValue] else {
                    break
                }
                self?.currentElement?.newTag(key, value: value)
            case XMLName.Node.rawValue:
                self?.currentElement = OSMNode(xmlAttributes:attributeDict)
            case XMLName.Way.rawValue:
                self?.currentElement = OSMWay(xmlAttributes:attributeDict)
            case XMLName.WayNode.rawValue:
                guard let ndString = attributeDict[XMLAttributes.Ref.rawValue] else {
                    break
                }
                
                guard let nd = Int64(ndString) else {
                    break
                }
                
                if let way = self?.currentElement as? OSMWay {
                    way.nodes.append(nd)
                }
            case XMLName.Relation.rawValue:
                self?.currentElement = OSMRelation(xmlAttributes:attributeDict)
            case XMLName.Member.rawValue:
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
                let member = OSMRelationMember(type: type, reference: ref,role:attributeDict[XMLAttributes.Role.rawValue])
                guard let relation = self?.currentElement as? OSMRelation else {
                    break
                }
                relation.members.append(member)
            default:
                break
            }
        }
        
    }
    
    @objc public func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        dispatch_async(self.workQueue) { () -> Void in
            switch elementName {
            case XMLName.Node.rawValue: fallthrough
            case XMLName.Way.rawValue: fallthrough
            case XMLName.Relation.rawValue:
                if let element = self.currentElement {
                    dispatch_async(self.delegateQueue, {[weak self] () -> Void in
                        if self != nil {
                            self?.delegate?.didFindElement(self!, element: element)
                        }
                    })
                    
                }
            default:
                break
            }
        }
    }
    
    @objc public func parserDidEndDocument(parser: NSXMLParser) {
        dispatch_async(self.workQueue) { () -> Void in
            dispatch_async(self.delegateQueue, { () -> Void in
                self.delegate?.didFinishParsing(self)
            })
        }
    }
    
}
