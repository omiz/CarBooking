//
//  BookingNotificationCell.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/22/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import UIKit
import UserNotifications

class BookingNotificationCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(_ booking: Booking?, notificationRequest: UNNotificationRequest) {
        
        let scheduledDate = booking?.scheduleDate(in: notificationRequest)
        
        let isBookingDate = scheduledDate == booking?.date
        
        label.text = isBookingDate ? "At the event start" : scheduledDate?.formatted
    }
    
}

