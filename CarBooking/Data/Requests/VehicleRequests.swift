//
//  VehicleRequests.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/18/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import Foundation
import TRON

struct VehicleRequests {
    
    let tron: TRON
    
    init(tron: TRON) {
        self.tron = tron
    }
    
    func all() -> APIRequest<DecodableArray<Vehicle>,DataErrorObject> {
        let request: APIRequest<DecodableArray<Vehicle>,DataErrorObject> = tron.request("cars.json")
        return request
    }
    
    func detail(for id: Int) -> APIRequest<VehicleDetail,DataErrorObject> {
        let request: APIRequest<VehicleDetail,DataErrorObject> = tron.request("cars/\(id).json")
        return request
    }
}
