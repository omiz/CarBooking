//
//  BookingRequests.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/18/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import Foundation
import TRON

struct BookingRequests {
    
    let tron: TRON
    
    init(tron: TRON) {
        self.tron = tron
    }
    
    func all() -> APIRequest<DecodableArray<Booking>,DataErrorObject> {
        
        //TODO: add authentications and get from the server
        let request: APIRequest<DecodableArray<Booking>,DataErrorObject> = tron.request("booking.json")
        return request
    }
    
    func book(_ object: Booking) -> APIRequest<Booking,DataErrorObject> {
        
        //TODO: add authentications and post to the server
        let request: APIRequest<Booking,DataErrorObject> = tron.request("book.json")

        request.method = .post
        
        request.object = object

        //TODO: update booking parameters
        request.parameters = ["id": object.id,
                              "date": object.date?.timeIntervalSince1970 as Any,
                              "duration": object.duration as Any]

        return request
    }
    
    func update(_ object: Booking) -> APIRequest<Booking,DataErrorObject> {
        
        //TODO: add authentications and post to the server
        let request: APIRequest<Booking,DataErrorObject> = tron.request("book.json")
        
        request.method = .put
        
        request.object = object
        
        request.objectId = object.id
        
        //TODO: update booking parameters
        request.parameters = ["id": object.id,
                              "date": object.date?.timeIntervalSince1970 as Any,
                              "duration": object.duration as Any]
        
        return request
    }
    
    func delete(_ object: Booking) -> APIRequest<Booking,DataErrorObject> {
        
        //TODO: add authentications and delete on the server
        let request: APIRequest<Booking,DataErrorObject> = tron.request("book.json")
        
        request.method = .delete
        
        request.objectId = object.id
        
        //TODO: update deletion parameters for booking
        request.parameters = ["id": object.id]
        
        return request
    }
}
