//
//  TabBarController.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/18/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        removeTabbarItemText()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func removeTabbarItemText() {
        let inset = UIEdgeInsetsMake(6, 0, -6, 0)
        tabBar.items?.forEach {
            $0.title = nil
            $0.imageInsets = inset
        }
    }
    

    func showAllVehiclesTab() {
        selectedIndex = 0
    }
    
    func showMyBookingsTab() {
        selectedIndex = 1
    }
    
    func showContactsTab() {
        selectedIndex = 2
    }

}
