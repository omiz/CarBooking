//
//  DecodableArray.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/18/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import Foundation

import Foundation
import SwiftyJSON
import TRON

class DecodableArray<Element: JSONDecodable>: NSObject, JSONDecodable {
    
    let rawValue: String
    
    let array: [Element]
    
    override var description: String {
        return rawValue
    }
    
    override var debugDescription: String {
        return rawValue
    }
    
    required init(json: JSON) throws {
        
        if json["error"].intValue < 0 {
            throw DataError.serverError
        }
        
        array = json.arrayValue.map { try? Element(json: $0) }.filter { $0 != nil } as? [Element] ?? []
        
        rawValue = json.description
    }
}
