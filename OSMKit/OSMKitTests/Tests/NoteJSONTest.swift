//
//  NoteJSONTest.swift
//  OSMKit
//
//  Created by David Chiles on 2/8/16.
//
//

import XCTest
@testable import OSMKit_Swift

class NotesJSONTest: XCTestCase {
    
    var data:NSData? = nil
    
    override func setUp() {
        super.setUp()
        let fileURL = NSBundle(forClass: self.dynamicType).URLForResource("notes", withExtension: "json")
        self.data = NSData(contentsOfURL: fileURL!)
    }
    
    func testDecoder() {
        do {
            let notes = try JSONDecoder.notes(self.data!)
            XCTAssertNotNil(notes,"nil notes")
            XCTAssertTrue(notes.count == 100, "Incorrect note count")
            let commentCount = notes.reduce(0, combine: { (total, note) in
                total+note.comments!.count
            })
            XCTAssertTrue(commentCount == 157,"Incorrect comment count")
        }
        catch let error {
           XCTAssertNil(error,"Error \(error)")
        }
    }
    
    func testDecoderSpeed() {
        self.measureBlock { () -> Void in
            let notes = try! JSONDecoder.notes(self.data!)
            XCTAssertNotNil(notes)
        }
    }
}

class NoteJSONTest: XCTestCase {
    
    var data:NSData? = nil
    
    override func setUp() {
        super.setUp()
        let fileURL = NSBundle(forClass: self.dynamicType).URLForResource("note", withExtension: "json")
        self.data = NSData(contentsOfURL: fileURL!)
    }
    
    func testDecoder() {
        
        do {
            let note = try JSONDecoder.note(self.data!)
            XCTAssertTrue(note.longitude == -0.1495976,"Wrong Longitude")
            XCTAssertTrue(note.latitude == 51.6146546,"Wrong Latitude")
            XCTAssertTrue(note.osmIdentifier == 267211,"Wrong OSM ID")
            XCTAssertTrue(note.open == false, "Wrong state")
            XCTAssertTrue(note.dateCreated == "2014-11-07 13:08:03 UTC", "Wrong Date")
            XCTAssertTrue(note.dateClosed == "2016-02-08 22:43:50 UTC", "Wrong Date")
            XCTAssertTrue(note.url == NSURL(string: "http://api.openstreetmap.org/api/0.6/notes/267211.json"),"Wrong URL")
            XCTAssertTrue(note.comments?.count == 2, "Wrong Comment Count")
            
            let comment1 = note.comments![0]
            XCTAssertTrue(comment1.dateString == "2014-11-07 13:08:03 UTC", "Wrong date string")
            XCTAssertTrue(comment1.action == .Open, "Wrong state")
            XCTAssertTrue(comment1.text == "this building has a continuous shop front around the corner")
            
            let comment2 = note.comments![1]
            XCTAssertTrue(comment2.dateString == "2016-02-08 22:43:50 UTC", "Wrong date string")
            XCTAssertTrue(comment2.action == .Closed, "Wrong state")
            XCTAssertTrue(comment2.text == "I'd hardly describe it as a continuous shopfront. There is a roller shutter concealing a shopfront across most of the width at the Friern Barnet side. There is a small roller shutter about 4 feet across the corner bevel, concealing an entrance door. The Carlton Road side is mostly hidden by an advertising hoarding -- maybe there is a storefront behind it, but the hoarding looks fairly permanent. The shutters were down (at 3pm in the afternoon) so I think the shop may not be in current use. Consequently I'm just adding the corner bevel, adjusting the perimeter to be more like that on bing but not adding any shop details unless somebody cares to re-open this.","Wrong text")
            XCTAssertTrue(comment2.userId == 20094, "Wrong user id")
            XCTAssertTrue(comment2.username == "harg", "Wrong username")
            
            XCTAssertNotNil(note,"nil note")
        }
        catch let error {
            XCTAssertNil(error,"Error: \(error)")
        }
        
        
    }
}