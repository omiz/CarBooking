//
//  BookedVehiclesViewController.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/18/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import UIKit

class BookedVehiclesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTitle() {
        navigationItem.title = "Booked".localized
    }


}

