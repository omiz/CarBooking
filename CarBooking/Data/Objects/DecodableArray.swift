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

protocol JSONDecodableArray: BaseObject {
    
    associatedtype Element
    
    var array: [Element] { get }
}

class DecodableArray<E: JSONDecodable>: NSObject, NSCoding, JSONDecodableArray {
    
    var id: Int = 0
    
    typealias Element = E
    
    
    let rawValue: String
    
    let array: [E]
    
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
    
    required init(coder decoder: NSCoder) {
        rawValue = decoder.decodeObject(forKey: "rawValue") as? String ?? ""
        array = decoder.decodeObject(forKey: "array")  as? [Element] ?? []
    }
    
    
    func encode(with coder: NSCoder) {
        coder.encode(rawValue, forKey: "rawValue")
        coder.encode(array, forKey: "array")
    }
    
    static func ==(lhs: DecodableArray, rhs: DecodableArray) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
