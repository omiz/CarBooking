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

class Booking: NSObject {
    
    var id: Int
    var vehicle: VehicleDetail
    var date: Date?
    
    var isBooked: Bool {
        return date != nil
    }
    override var description: String {
        return ["id": id, "vehicle": vehicle, "date": date?.description ?? "Not set"].description
    }
    
    init(vehicle: VehicleDetail) {
        self.id = 0
        self.vehicle = vehicle
    }
    
    static func ==(_ lhs: Booking, _ rhs: Booking) -> Bool {
        return lhs.id == rhs.id
    }
}

