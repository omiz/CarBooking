//
//  Date.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/20/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import Foundation

extension Date {
    var formatted: String {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        formatter.doesRelativeDateFormatting = true
        
        return formatter.string(from: self)
    }
}
