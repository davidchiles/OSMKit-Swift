//
//  XMLTest.swift
//  OSMKit
//
//  Created by David Chiles on 1/4/16.
//  Copyright © 2016 David Chiles. All rights reserved.
//

import XCTest
@testable import OSMKit_Swift

class XMLTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testNodeXML() {
        let node = testNode()
        let xml = OSMXML.xmlForElement(node)
        XCTAssertNotNil(xml)
    }
    
    func testWayXML() {
        let way = testWay()
        let xml = OSMXML.xmlForElement(way)
        XCTAssertNotNil(xml)
    }
    
    func testRelationXML() {
        let relation = testRelation()
        let xml = OSMXML.xmlForElement(relation)
        XCTAssertNotNil(xml)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
