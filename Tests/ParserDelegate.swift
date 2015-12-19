//
//  ParserDelegate.swift
//  OSMKit
//
//  Created by David Chiles on 12/18/15.
//  Copyright © 2015 David Chiles. All rights reserved.
//

import Foundation
import OSMKit

class ParserDelegate:OSMParserDelegate {
    
    var startBlock:(parser:OSMParser) -> Void
    var endBlock:(parser:OSMParser) -> Void
    var nodeBlock:(parser:OSMParser,node:OSMNode) -> Void
    var wayBlock:(parser:OSMParser,way:OSMWay) -> Void
    var relationBlock:(parser:OSMParser,relation:OSMRelation) -> Void
    var errorBlock:(parser:OSMParser,error:ErrorType?) -> Void
    
    init(startBlock:(parser:OSMParser) -> Void,nodeBlock:(parser:OSMParser,node:OSMNode) -> Void,wayBlock:(parser:OSMParser,way:OSMWay) -> Void,relationBlock:(parser:OSMParser,relation:OSMRelation) -> Void,endBlock:(parser:OSMParser) -> Void,errorBlock:(parser:OSMParser,error:ErrorType?) -> Void) {
        self.startBlock = startBlock
        self.nodeBlock = nodeBlock
        self.wayBlock = wayBlock
        self.relationBlock = relationBlock
        self.errorBlock = errorBlock
        self.endBlock = endBlock
    }
    
    //MARK: OSMParserDelegate Methods
    func didStartParsing(parser: OSMParser) {
        self.startBlock(parser: parser)
    }
    
    func didFindElement(parser: OSMParser, element: OSMElement) {
        switch element {
        case let element as OSMNode:
            self.nodeBlock(parser: parser, node: element)
        case let element as OSMWay:
            self.wayBlock(parser: parser, way: element)
        case let element as OSMRelation:
            self.relationBlock(parser: parser, relation: element)
        default:
            break
        }
    }
    
    func didFinishParsing(parser: OSMParser) {
        self.endBlock(parser: parser)
    }
    
    func didError(parser: OSMParser, error: ErrorType?) {
        self.errorBlock(parser: parser, error: error)
    }
}