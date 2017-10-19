//
//  UITableView.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/19/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func dynamicHeight(estimated: CGFloat) {
        rowHeight = UITableViewAutomaticDimension
        estimatedRowHeight = estimated
    }
    
    func removeExtraCells() {
        tableFooterView = UIView()
    }
    
    func cell<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: typeName(type.self), for: indexPath) as! T
    }
}
