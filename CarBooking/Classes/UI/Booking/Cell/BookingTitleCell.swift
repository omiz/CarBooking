//
//  BookingTitleCell.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/19/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import UIKit

class BookingTitleCell: UITableViewCell {

    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Label.text = "Booking of".localized
        detailButton.setTitle("View".localized, for: .normal)
        detailButton.layer.cornerRadius = cornerRadius
        detailButton.backgroundColor = .primary
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(_ booking: Booking?) {
        descriptionLabel.text = booking?.vehicle?.name
    }

}
