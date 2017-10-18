//
//  ThemeManager.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/18/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import Foundation
import UIKit

struct ThemeManager {
    
    static func apply() {
        
        UIApplication.shared.delegate?.window??.tintColor = .primary
        
        UITabBar.appearance().barTintColor = .primary
        UITabBar.appearance().tintColor = .secondary
        UITabBar.appearance().isTranslucent = false
        
        UINavigationBar.appearance().barTintColor = .primary
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.accent]
        UINavigationBar.appearance().isTranslucent = false
        
        UISwitch.appearance().onTintColor = UIColor.primary.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = .primary
        
        UIButton.appearance().tintColor = .primary
    }
}

