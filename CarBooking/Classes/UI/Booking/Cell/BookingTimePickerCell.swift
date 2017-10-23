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

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerTopLabel: UILabel!
    @IBOutlet weak var datePickerHeightConstraint: NSLayoutConstraint!
    
    var extended: Bool = false { didSet {
        datePickerHeightConstraint.constant = extended ? 200 : 0
        datePicker.layoutIfNeeded()
        }
    }
    
    var delegate: BookingTimeDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateLabel.adjustsFontSizeToFitWidth = true
        
        datePicker.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
        
        pickerTopLabel.text = "You can not change the date for old Bookings".localized
    }
    
    @objc func timeChanged(_ picker: UIDatePicker) {
        setDateLabel(text: picker.date.formatted)
        
        delegate?.bookingTime(changed: picker.date)
    }
    
    func setup(_ booking: Booking?, delegate: BookingTimeDelegate?) {
        
        let date = booking?.date?.formatted ?? ""
        
        setDateLabel(text: date)
        
        let pickerDate = booking?.date ?? Booking.defaultDate
        
        check(isInPast: pickerDate)
        
        datePicker.setDate(booking?.date ?? Booking.defaultDate, animated: false)
        
        self.delegate = delegate
    }
    
    func setDateLabel(text: String) {
        dateLabel.text = text.isEmpty ? "Booking date is not available".localized :
            String(format: "Starting date: %@".localized, text)
    }
    
    func check(isInPast date: Date) {
        let isInTheFuture = date.timeIntervalSinceNow >= 0
        
        datePicker.minimumDate = isInTheFuture ? Date() : nil
        datePicker.isEnabled = isInTheFuture
        
        pickerTopLabel.isHidden = isInTheFuture
    }
}
