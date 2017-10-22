//
//  Vehicle.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/18/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import Foundation
import SwiftyJSON
import TRON

class Vehicle: NSObject, NSCoding, BaseObject {
    
    let rawValue: String
    
    var id: Int
    let name: String
    let shortDescription: String
    
    var hasDescription: Bool {
        return !shortDescription.isEmpty
    }
    
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
        
        guard json["id"].int != nil else {
            throw DataError.parsingError
        }
        
        id = json["id"].intValue
        name = json["name"].stringValue
        shortDescription = json["shortDescription"].stringValue
        
        rawValue = json.description
    }
    
    required init(coder decoder: NSCoder) {
        rawValue = decoder.decodeObject(forKey: "rawValue") as? String ?? ""
        id = decoder.decodeInteger(forKey: "id")
        name = decoder.decodeObject(forKey: "name")  as? String ?? ""
        shortDescription = decoder.decodeObject(forKey: "shortDescription")  as? String ?? ""
    }
    
    
    func encode(with coder: NSCoder) {
        coder.encode(rawValue, forKey: "rawValue")
        coder.encode(id, forKey: "id")
        coder.encode(name, forKey: "name")
        coder.encode(shortDescription, forKey: "shortDescription")
    }
    
    static func ==(_ lhs: Vehicle, _ rhs: Vehicle) -> Bool {
        return lhs.id == rhs.id
    }
}
