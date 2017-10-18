//
//  UIImageView.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/19/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func load(_ imageName: String?, placeholder: UIImage? = nil) {
        
        let link = DataManager.baseURL + "api/" + (imageName ?? "")
        
        let url = URL(string: link)
        
        kf.setImage(with: url, placeholder: placeholder)
    }
}
