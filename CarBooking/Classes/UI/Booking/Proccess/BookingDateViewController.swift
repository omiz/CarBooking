//
//  BookingDateViewController.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/19/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import UIKit

class BookingDateViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //TODO: Move navigation buttons to a custom view
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var buttonsContainerStackView: UIView!
    
    @IBOutlet weak var confirmbutton: UIButton!
    @IBOutlet weak var dismissbutton: UIButton!
    
    var vehicle: VehicleDetail?
    
    var date: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    func prepareView() {
        
        setupView()
        
        setupTexts()
        
        setupColors()
        
        setupDate()
    }
    
    func setupTexts() {
        label.text = "Please select the starting date".localized
        confirmbutton.setTitle("Next".localized, for: .normal)
        dismissbutton.setTitle("Dismiss", for: .normal)
    }
    
    func setupColors() {
        buttonsContainerView.backgroundColor = .primary
    }
    
    func setupView() {
        buttonsContainerView.layer.cornerRadius = cornerRadius
    }
    
    func setupDate() {
        datePicker.minimumDate = Date()
        
        datePicker.date = Booking.defaultDate
        
        date = datePicker.date
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(_ datePicker: UIDatePicker) {
        date = datePicker.date
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        guard vehicle != nil else { return false }
        
        guard date != nil else { return false }
        
        return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        setupDurationController(from: segue)
    }
    
    func setupDurationController(from segue: UIStoryboardSegue) {
        
        guard let controller = segue.destination as? BookingDurationViewController else { return }
        
        controller.vehicle = vehicle
        controller.date = date
    }
 
    @IBAction func closeAction(_ sender: UIButton) {
        dismiss(animated: true)
    }

}
