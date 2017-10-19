//
//  VehicleCollectionViewCell.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/18/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import UIKit

class VehicleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    
    override var isHighlighted: Bool {
        get { return super.isHighlighted }
        set {
            containerView.transform = newValue ? CGAffineTransform(scaleX: 0.99, y: 0.99) : CGAffineTransform.identity
            super.isHighlighted = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func setupView() {
        containerView.backgroundColor = .primary
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
        
        nameTextLabel.textColor = .accent
        descriptionTextLabel.textColor = .accent
    }
    
    
    func setup(_ item: Vehicle) {
        nameTextLabel.text = item.name
        descriptionTextLabel.text = item.hasDescription ? item.shortDescription : "No description available".localized
    }
}
