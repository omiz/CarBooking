//
//  Utility.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/18/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import Foundation
import UIKit

func typeName(_ some: Any) -> String {
    return (some is Any.Type) ? "\(some)" : "\(type(of: (some) as AnyObject))"
}

var cornerRadius: CGFloat = 5.0
