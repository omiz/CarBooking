//
//  BookingDetailCell.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/20/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import UIKit

class BookingDetailCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    
    override var isHighlighted: Bool {
        get { return super.isHighlighted }
        set {
            containerView.transform = newValue ? CGAffineTransform(scaleX: 0.95, y: 0.95) : CGAffineTransform.identity
            super.isHighlighted = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func setupView() {
        containerView.backgroundColor = .primary
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
        
        nameTextLabel.textColor = .accent
        descriptionTextLabel.textColor = .accent
    }
    
    
    func setup(_ item: Booking) {
        nameTextLabel.text = item.vehicle?.name
        descriptionTextLabel.text = item.date?.formatted
    }
}
