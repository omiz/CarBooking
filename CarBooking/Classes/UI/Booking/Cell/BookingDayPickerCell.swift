//
//  BookingDayPickerCell.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/22/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import Foundation
import UIKit

protocol BookingDayDelegate {
    func bookingDay(changed days: Int)
}

class BookingDayPickerCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayPicker: UIPickerView!
    @IBOutlet weak var pickerTopLabel: UILabel!
    @IBOutlet weak var pickerHeightConstraint: NSLayoutConstraint!
    
    var extended: Bool = false { didSet {
        pickerHeightConstraint.constant = extended ? 200 : 0
        dayPicker.layoutIfNeeded()
        }
    }
    
    var dataSouce: [String] = Booking.allowedDaysCount.map { $0.description }
    
    var delegate: BookingDayDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dayLabel.adjustsFontSizeToFitWidth = true
        
        pickerTopLabel.text = "You can not change the days count for old Bookings".localized
    }
    
    @objc func timeChanged(_ picker: UIDatePicker) {
        dayLabel.text = String(format: "Starting date: %@".localized, picker.date.formatted)
        
        delegate?.bookingDay(changed: 0)
    }
    
    func setup(_ booking: Booking?, delegate: BookingDayDelegate?) {
        
        let date = booking?.date?.formatted ?? ""
        dayLabel.text = date.isEmpty ? "Booking date is not available".localized :
            String(format: "Starting date: %@".localized, date)
        
        check(isInPast: booking)
        
        let duration = booking?.duration ?? 1
        
        let index = dataSouce.index(of: duration.description) ?? 0
        
        dayPicker.selectRow(index, inComponent: 0, animated: false)
        
        setDayLabel(count: booking?.duration)
        
        self.delegate = delegate
    }
    
    func check(isInPast booking: Booking?) {
        
        let isInTheFuture = (booking?.date?.timeIntervalSinceNow ?? -1) >= 0
        
        dayPicker.isUserInteractionEnabled = isInTheFuture
        
        pickerTopLabel.isHidden = isInTheFuture
    }
    
    func setDayLabel(count: Int?) {
        
        let days = (count ?? 0) > 1 ? "days" : "day"
        
        dayLabel.text = count == nil  ? "Booking duration is not available".localized :
            String(format: "For: %d %@".localized, count ?? 0, days)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSouce.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSouce[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.bookingDay(changed: Int(dataSouce[row]) ?? 0)
    }
}

