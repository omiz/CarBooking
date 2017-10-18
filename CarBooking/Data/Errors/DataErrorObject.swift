//
//  DataErrorObject.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/18/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import Foundation
import SwiftyJSON
import TRON

class DataErrorObject : NSObject, JSONDecodable {
    var error: Int
    
    var rawValue: String
    
    override var description: String {
        return rawValue
    }
    
    required init(json: JSON) {
        error = json["error"].intValue
        
        rawValue = json.description
    }
    
    func alert(in c: UIViewController, _ handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        
        //TODO: show an error alert for the user
        print(error, description)
    }
}
