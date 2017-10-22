//
//  BaseObject.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/22/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import Foundation
import TRON

protocol BaseObject: JSONDecodable {
    var id: Int { get set }
}
