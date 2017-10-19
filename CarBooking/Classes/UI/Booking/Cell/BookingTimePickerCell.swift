//
//  BookingTimePickerCell.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/19/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import UIKit

protocol BookingTimeDelegate {
    func bookingTime(changed date: Date)
}

class BookingTimePickerCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerHeightConstraint: NSLayoutConstraint!
    
    var delegate: BookingTimeDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
    }
    
    @objc func timeChanged(_ picker: UIDatePicker) {
        dateLabel.text = picker.date.description
        
        delegate?.bookingTime(changed: picker.date)
    }

}
