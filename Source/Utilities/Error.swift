//
//  Error.swift
//  Pods
//
//  Created by David Chiles on 2/8/16.
//
//

import Foundation

enum JSONParsingError : ErrorType {
    case InvalidJSONStructure
    case CannotDecodeKey(key:JSONKeys)
}