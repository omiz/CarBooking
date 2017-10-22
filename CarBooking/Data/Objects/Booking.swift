//
//  Booking.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/18/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import Foundation
import SwiftyJSON
import TRON

class Booking: NSObject, NSCoding, BaseObject {
    
    var id: Int = 0
    var vehicle: VehicleDetail?
    var date: Date?
    var duration: Int?
    
    var isBooked: Bool {
        return date != nil
    }
    override var description: String {
        return ["id": id,
                "vehicle": vehicle?.description ?? "Not set",
                "date": date?.description ?? "Not set"].description
    }
    
    override init() { super.init() }
    
    init(vehicle: VehicleDetail) {
        super.init()
        self.vehicle = vehicle
    }
    
    required init(json: JSON) throws {
        id = json["id"].intValue
        vehicle = try VehicleDetail(json: json["vehicle"])
        
        let timestamp = json["date"].double
        
        if let timestamp = timestamp {
            date = Date(timeIntervalSince1970: timestamp)
        }
        
        let duration = json["duration"].int
        
        if let duration = duration {
            self.duration = duration
        }
    }
    
    required init(coder decoder: NSCoder) {
        id = decoder.decodeInteger(forKey: "id")
        vehicle = decoder.decodeObject(forKey: "vehicle")  as? VehicleDetail
        date = decoder.decodeObject(forKey: "date") as? Date
        duration = decoder.decodeObject(forKey: "duration") as? Int
    }
    
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(vehicle, forKey: "vehicle")
        coder.encode(date, forKey: "date")
        coder.encode(duration, forKey: "duration")
    }
    
    static func ==(_ lhs: Booking, _ rhs: Booking) -> Bool {
        return lhs.id == rhs.id
    }
}

