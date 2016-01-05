//
//  OSMAPITest.swift
//  OSMKit
//
//  Created by David Chiles on 12/21/15.
//  Copyright © 2015 David Chiles. All rights reserved.
//

import XCTest
import CoreLocation
@testable import OSMKit_Swift

class OSMAPITest: XCTestCase {
    
    var client = OSMAPIManager(apiConsumerKey: "", apiPrivateKey: "", token: "", tokenSecret: "")

    override func setUp() {
        super.setUp()
        self.client.URL = .Dev
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetMap() {
        let box = BoundingBox(left: -122.27195, right: -122.26917, bottom: 37.87107, top: 37.87251)
        let expectation = self.expectationWithDescription("getMap")
        self.client.downloadBoundingBox(box) { (data) -> Void in
            XCTAssertNotNil(data)
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(100, handler: nil)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
