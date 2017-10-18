//
//  DataManager.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/18/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import Foundation
import TRON

class DataManager {
    
    static var isTestServer: Bool {
        return baseURL.contains("-test")
    }
    
    static var baseURL: String {
        return "http://job-applicants-dummy-api.kupferwerk.net.s3.amazonaws.com/"
    }
    
    fileprivate static let tron = TRON(baseURL: baseURL + "api/", plugins: [NetworkActivityPlugin(application: UIApplication.shared)])
    
    let vehicles = VehicleRequests(tron: tron)
    
    //WARN: Do not use
    let bookings = BookingRequests(tron: tron)
    
    static let shared = DataManager()
    
    fileprivate init() {}
    
    func stopAll() {
        DataManager.tron.manager.session.getAllTasks { $0.forEach { $0.cancel() } }
        
    }
}
