//
//  JSONDecoder.swift
//  Pods
//
//  Created by David Chiles on 1/15/16.
//
//

import Foundation

internal enum JSONKeys: String {
    case Geometry = "geometry"
    case Coordinates = "coordinates"
    case Properties = "properties"
    case ID = "id"
    case URL = "url"
    case Status = "status"
    case DateCreated = "date_created"
    case DateClosed = "closed_at"
    case Comments = "comments"
    case Text = "text"
    case Date = "date"
    case Action = "action"
    case UID = "uid"
    case User = "user"
}

internal enum NoteStatusValue: String {
    case open = "open"
    case closed = "closed"
    
}

public enum OSMCommentAction: String {
    case Open      = "opened"
    case Closed    = "closed"
    case Commented = "commented"
}

public class JSONDecoder {
    
    public class func comment(dictionary:[String:AnyObject]) throws -> OSMComment {
        
        
        guard let dateString = dictionary[JSONKeys.Date.rawValue] as? String else {
            throw JSONParsingError.CannotDecodeKey(key: .Date)
        }
        
        guard let actionString = dictionary[JSONKeys.Action.rawValue] as? String else {
            throw JSONParsingError.CannotDecodeKey(key: .Action)
        }
        
        guard let action = OSMCommentAction(rawValue: actionString) else {
            throw JSONParsingError.CannotDecodeKey(key: .Action)
        }
        
        let text = dictionary[JSONKeys.Text.rawValue] as? String
        
        let uid = dictionary[JSONKeys.UID.rawValue] as? NSNumber
        
        let username = dictionary[JSONKeys.User.rawValue] as? String
        
        var comment = OSMComment(dateString: dateString, action: action)
        comment.text = text
        comment.userId = uid?.longLongValue
        comment.username = username
        
        return comment
    }
    
    public class func note(data:NSData) throws -> OSMNote {
        guard let noteDict = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String:AnyObject] else {
            throw JSONParsingError.InvalidJSONStructure
        }
        
        guard let geometry = noteDict[JSONKeys.Geometry.rawValue] as? [String:AnyObject] else {
            throw JSONParsingError.CannotDecodeKey(key: JSONKeys.Geometry)
        }
        
        guard let coordinates = geometry[JSONKeys.Coordinates.rawValue] as? [Double] else {
            throw JSONParsingError.CannotDecodeKey(key: JSONKeys.Coordinates)
        }
        
        if coordinates.count != 2 {
            throw JSONParsingError.InvalidJSONStructure
        }
        
        let lon = coordinates[0]
        let lat = coordinates[1]
        
        
        guard let properties = noteDict[JSONKeys.Properties.rawValue] as? [String:AnyObject] else {
            throw JSONParsingError.CannotDecodeKey(key: JSONKeys.Properties)
        }
        
        guard let id = (properties[JSONKeys.ID.rawValue] as? NSNumber)?.longLongValue else {
            throw JSONParsingError.CannotDecodeKey(key: JSONKeys.ID)
        }
        
        guard let urlString = properties[JSONKeys.URL.rawValue] as? String else {
            throw JSONParsingError.CannotDecodeKey(key: JSONKeys.URL)
        }
        let url = NSURL(string: urlString)
        
        let status = (properties[JSONKeys.Status.rawValue] as? String) == NoteStatusValue.open.rawValue
        
        guard let dateCreated = properties[JSONKeys.DateCreated.rawValue] as? String else {
            throw JSONParsingError.CannotDecodeKey(key: JSONKeys.DateCreated)
        }
        
        guard let dateClosed = properties[JSONKeys.DateClosed.rawValue] as? String else {
            throw JSONParsingError.CannotDecodeKey(key: JSONKeys.DateClosed)
        }
        
        guard let commentsArray = properties[JSONKeys.Comments.rawValue] as? [[String:AnyObject]] else {
            throw JSONParsingError.CannotDecodeKey(key: JSONKeys.Comments)
        }
        
        var comments = [OSMComment]()
        for commentDictionary in commentsArray {
            let comment = try self.comment(commentDictionary)
            comments.append(comment)
        }
        
        let note = OSMNote(osmIdentifier: id, latitude: lat, longitude: lon, open: status, dateCreated: dateCreated, dateClosed:dateClosed, url:url )
        
        note.comments = comments
        
        return note
    }
}