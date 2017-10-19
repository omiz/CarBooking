//
//  BookingDetailViewController.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/19/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import UIKit

class BookingDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var booking: Booking?
    
    var vehicle: VehicleDetail?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTable()
    }

    func setupTable() {
    
        tableView.dynamicHeight(estimated: 44)
        tableView.removeExtraCells()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booking != nil ? 2 : 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return tableView.cell(BookingTitleCell.self, for: indexPath)
            
        case 1:
            return tableView.cell(BookingTimePickerCell.self, for: indexPath)
            
        default:
            return UITableViewCell(frame: CGRect.zero)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
