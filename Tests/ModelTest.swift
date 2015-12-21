//
//  ModelTest.swift
//  OSMKit-Swift
//
//  Created by David Chiles on 12/15/15.
//  Copyright © 2015 David Chiles. All rights reserved.
//

import XCTest
@testable import OSMKit

class ModelTest: XCTestCase {
    
    let version = 2
    let id:Int64 = 35719005
    let lon = -122.2319067
    let lat = 37.8815080
    let visible = true
    let changeset:Int64 = 2908326
    var date = NSDate()
    let nodeAttributes:[String:String] = ["version":"2","id":"35719005","lon":"-122.2319067","lat":"37.8815080","visible":"true","timestamp":"2009-10-21T02:05:20Z","user":"Speight","uid":"24452","changeset":"2908326"]

    override func setUp() {
        super.setUp()
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let dateComponents = NSDateComponents()
        dateComponents.day = 21
        dateComponents.month = 10
        dateComponents.year = 2009
        dateComponents.hour = 2
        dateComponents.minute = 5
        dateComponents.second = 20
        dateComponents.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        self.date = (calendar?.dateFromComponents(dateComponents))!
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func createNode() -> OSMNode {
        return OSMNode(xmlAttributes: self.nodeAttributes)
    }

    func testNodeModel() {
        let node = self.createNode()
        XCTAssertEqual(self.version, node.version)
        XCTAssertEqual(self.id, node.osmIdentifier)
        XCTAssertEqual(self.lat, node.latitude)
        XCTAssertEqual(self.lon, node.longitude)
        XCTAssertEqual(self.changeset, node.changeset)
        XCTAssertEqual(self.visible, node.visible)
        XCTAssertEqual(self.date, node.timeStamp)
        
        let coordinate = node.coordinate
        XCTAssertEqual(self.lat, coordinate.latitude)
        XCTAssertEqual(self.lon, coordinate.longitude)
    }

    func testNodePerformance() {
        // This is an example of a performance test case.
        self.measureBlock {
            for _ in 1...1000 {
                _ = self.createNode()
            }
            
        }
    }

}
