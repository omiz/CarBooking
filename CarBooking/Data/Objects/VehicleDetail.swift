//
//  VehicleDetail.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/18/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import Foundation
import SwiftyJSON
import TRON

class VehicleDetail: Vehicle {
    
    let vehicleDescription: String
    let image: String
    
    required init(json: JSON) throws {
        
        vehicleDescription = json["description"].stringValue
        image = json["image"].stringValue
        
        try super.init(json: json)
    }
    
    static func ==(_ lhs: VehicleDetail, _ rhs: VehicleDetail) -> Bool {
        return lhs.id == rhs.id
    }
}

