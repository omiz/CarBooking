//
//  UICollectionView.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/18/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func cell<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: typeName(type.self), for: indexPath) as! T
    }
}
