//
//  OSMParserTest.swift
//  OSMKit
//
//  Created by David Chiles on 12/17/15.
//  Copyright © 2015 David Chiles. All rights reserved.
//

import XCTest
@testable import OSMKit_Swift

class OSMParserTest: XCTestCase {
    
    
    var data:NSData?
    var parser:OSMParser?

    override func setUp() {
        super.setUp()
        let fileURL = NSBundle(forClass: self.dynamicType).URLForResource("map", withExtension: "osm")
        self.data = NSData(contentsOfURL: fileURL!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testParser() {
        
        var nodeCount = 0
        var wayCount = 0
        var wayNodeCount = 0
        var relationCount = 0
        var memberCount = 0
        var tagCount = 0
        
        let expecation = self.expectationWithDescription("parser")
        
        let startBlock:(parser:OSMParser) -> Void = {parser in
            
        }
        
        let endBlock:(parser:OSMParser) -> Void = { parser in
            XCTAssertEqual(nodeCount, 12478)
            XCTAssertEqual(wayCount, 1699)
            XCTAssertEqual(relationCount, 120)
            XCTAssertEqual(memberCount, 3266)
            XCTAssertEqual(wayNodeCount, 14253)
            XCTAssertEqual(tagCount, 12843)
            expecation.fulfill()
        }
        
        let nodeBlock:(parser:OSMParser,element:OSMNode) -> Void = { parser,element in
            nodeCount += 1
            XCTAssertGreaterThan(element.osmIdentifier, 0)
            if let tags = element.tags {
                tagCount += tags.count
            }
        }
        
        let wayBlock:(parser:OSMParser,way:OSMWay) -> Void = { parser,way in
            wayCount += 1
            wayNodeCount += way.nodes.count
            if let tags = way.tags {
                tagCount += tags.count
            }
        }
        
        let relationBlock:(parser:OSMParser,relation:OSMRelation) -> Void = { parser, relation in
            relationCount += 1
            memberCount += relation.members.count
            if let tags = relation.tags {
                tagCount += tags.count
            }
        }
        
        let errorBlock:(parser:OSMParser,error:ErrorType?) -> Void = { parser, error in
            
        }
        
        let parseDelegate = ParserDelegate(startBlock: startBlock, nodeBlock: nodeBlock, wayBlock: wayBlock, relationBlock: relationBlock, endBlock: endBlock, errorBlock: errorBlock)
        
        self.parser = OSMParser(data: self.data!)
        self.parser?.delegate = parseDelegate
        self.parser?.parse()
        
        self.waitForExpectationsWithTimeout(100) { (error) -> Void in
            if let _ = error {
                print("\(error)")
            }
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            self.testParser()
        }
    }

}
