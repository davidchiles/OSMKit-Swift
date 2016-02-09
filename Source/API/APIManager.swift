//
//  APIManager.swift
//  
//
//  Created by David Chiles on 12/21/15.
//
//

import Foundation
import Alamofire

public enum APIURLString:String {
    case Public = "https://api.openstreetmap.org/api/0.6/"
    case Dev = "http://api06.dev.openstreetmap.org/api/0.6/"
    
    func endpoint(endpoint:APIEndpoint) -> String {
        return self.rawValue.stringByAppendingString(endpoint.rawValue)
    }
}

enum APIEndpoint:String {
    case Map = "map"
    case Notes = "notes.json"
    
}

internal enum Paramters:String {
    case BoundingBox = "bbox"
}

extension BoundingBox {
    func osmURLString() -> String {
        return "\(self.left),\(self.bottom),\(self.right),\(self.top)"
    }
}

public class OSMAPIManager {
    
    public var URL:APIURLString = .Public
    
    public let apiManager:Manager
    
    init(apiConsumerKey:String,apiPrivateKey:String,token:String,tokenSecret:String,configuration:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()) {
        self.apiManager = Alamofire.Manager(configuration: configuration)
    }
    
    
    //MARK: Downling data
    public func downloadBoundingBox(boundingBox:BoundingBox,completion:(data:NSData?,error:NSError?)->Void) {
        let bboxString = boundingBox.osmURLString()
        let parameters = [Paramters.BoundingBox.rawValue:bboxString]
        let urlString = self.URL.endpoint(.Map)
        self.apiManager.request(.GET, urlString, parameters: parameters, encoding: .URL, headers: nil).response { (request, response, data, error) -> Void in
            completion(data: data, error: error)
        }
    }
    
    //Mark: Downloading Notes
    public func downloadNotesBoundingBox(boundingBox:BoundingBox, completion:(data:NSData?,error:NSError?)->Void) {
        let bboxString = boundingBox.osmURLString()
        let parameters = [Paramters.BoundingBox.rawValue:bboxString]
        let urlString = self.URL.endpoint(.Notes)
        self.apiManager.request(.GET, urlString, parameters: parameters, encoding: .URL, headers: nil).response { (request, Response, data, error) -> Void in
            completion(data: data, error: error)
        }
    }
    
    //Mark Uploading Data
    
    public func openChangeset(tags:[String:String],completion:()->Void) {
        
    }
}
