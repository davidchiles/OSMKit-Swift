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
    case ID        = "id"
    case UID       = "uid"
    case User      = "user"
    case Version   = "version"
    case Changeset = "changeset"
    case Timestamp = "timestamp"
    case Visible   = "visible"
    case Latitude  = "lat"
    case Longitude = "lon"
    case Key       = "k"
    case Value     = "v"
    case Ref       = "ref"
    case Role      = "role"
    case Typ       = "type"
}

public class OSMParser:NSObject,NSXMLParserDelegate {
    
    public var delegate:OSMParserDelegate?
    public var delegateQueue = dispatch_queue_create("OSMParserDelegateQueue", nil)
    
    private var currentOperation:OSMParseOperation?
    private var endOperation = NSOperation()
    private let operationQueue = NSOperationQueue()
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
        self.operationQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0),{[weak self] () -> Void in
            self?.xmlParser.parse()
        })
    }
    
    func foundElement(element:OSMElement) {
        dispatch_async(self.delegateQueue, {[weak self] () -> Void in
            if self != nil {
                self?.delegate?.didFindElement(self!, element: element)
            }
        })
    }
    
    //MARK: NSXMLParserDelegate Methods
    
    @objc public func parserDidStartDocument(parser: NSXMLParser) {
        dispatch_async(self.workQueue) { () -> Void in
            
            self.endOperation.completionBlock = {() -> Void in
                dispatch_async(self.delegateQueue, { () -> Void in
                    self.delegate?.didFinishParsing(self)
                })
            }
            
            dispatch_async(self.delegateQueue, { () -> Void in
                self.delegate?.didStartParsing(self)
            })
        }
    }
    
    @objc public func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        dispatch_async(self.workQueue) {[weak self] () -> Void in
            
            if let name = XMLName(rawValue: elementName) {
                switch name {
                case .Node: fallthrough
                case .Way: fallthrough
                case .Relation:
                    let operation = OSMParseOperation(completion: { [weak self](element) -> Void in
                        self?.foundElement(element)
                    })
                    self?.endOperation.addDependency(operation)
                    self?.currentOperation = operation
                default:
                    break
                }
                self?.currentOperation?.add(name, attributes: attributeDict)
            }
            
        }
        
    }
    
    @objc public func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        dispatch_async(self.workQueue) { () -> Void in
            switch elementName {
            case XMLName.Node.rawValue: fallthrough
            case XMLName.Way.rawValue: fallthrough
            case XMLName.Relation.rawValue:
                if let operation = self.currentOperation {
                    self.operationQueue.addOperation(operation)
                }
                
                self.currentOperation = nil
            default:
                break
            }
        }
    }
    
    @objc public func parserDidEndDocument(parser: NSXMLParser) {
        dispatch_async(self.workQueue) { () -> Void in
            self.operationQueue.addOperation(self.endOperation)
        }
    }
    
}
