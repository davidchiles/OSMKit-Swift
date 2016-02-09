//
//  ModelTest.swift
//  OSMKit-Swift
//
//  Created by David Chiles on 12/15/15.
//  Copyright © 2015 David Chiles. All rights reserved.
//

import XCTest
@testable import OSMKit_Swift


let tags = ["key1":"value1","key2":"value2"]

let elementAttributes = ["version":"2","id":"35719005","visible":"true","timestamp":"2009-10-21T02:05:20Z","user":"Speight","uid":"24452","changeset":"2908326"]

public func testNode() -> OSMNode {
    var nodeAttributes = elementAttributes
    nodeAttributes["lat"] = "37.8815080"
    nodeAttributes["lon"] = "-122.2319067"
    let node = OSMNode(xmlAttributes: nodeAttributes)
    node.tags = tags
    return node
}

public func testWay() -> OSMWay {
    let way = OSMWay(xmlAttributes: elementAttributes)
    way.nodes = [1,2,3,4,5,6,7]
    return way
}

public func testRelation() -> OSMRelation {
    let relation = OSMRelation(xmlAttributes: elementAttributes)
    let member1 = OSMRelationMember(member: OSMID(type: .Node, ref: 1), role: nil)
    let member2 = OSMRelationMember(member: OSMID(type: .Way, ref: 34), role: "forward")
    let member3 = OSMRelationMember(member: OSMID(type: .Relation, ref: 22334), role: "backward")
    relation.members = [member1,member2,member3]
    
    return relation
}

class ModelTest: XCTestCase {
    
    let version = 2
    let id:Int64 = 35719005
    let lon = -122.2319067
    let lat = 37.8815080
    let visible = true
    let changeset:Int64 = 2908326
    var date = NSDate()
    

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

    func testNodeModel() {
        let node = testNode()
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
        
        node.addTag("key", value: "value")
        let tagsEqual = node.tags! == ["key":"value","key1":"value1","key2":"value2"]
        XCTAssertTrue(tagsEqual)
    }

    func testNodePerformance() {
        // This is an example of a performance test case.
        self.measureBlock {
            for _ in 1...1000 {
                _ = testNode()
            }
            
        }
    }

}
