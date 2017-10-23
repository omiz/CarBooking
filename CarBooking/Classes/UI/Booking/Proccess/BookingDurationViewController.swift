//
//  BookingDurationViewController.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/19/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import UIKit

class BookingDurationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    //TODO: Move navigation buttons to a custom view
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var buttonsContainerStackView: UIView!
    
    @IBOutlet weak var confirmbutton: UIButton!
    @IBOutlet weak var dismissbutton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var dataSouce: [String] = Booking.allowedDaysCount.map { $0.description }
    
    var vehicle: VehicleDetail?
    
    var date: Date?
    
    var duration: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    func prepareView() {
        
        setupView()
        
        setupTexts()
        
        setupColors()
        
        setupDuration()
    }
    
    func setupTexts() {
        label.text = "For how many days".localized
        confirmbutton.setTitle("Next".localized, for: .normal)
        dismissbutton.setTitle("Dismiss".localized, for: .normal)
        backButton.setTitle("Back".localized, for: .normal)
    }
    
    func setupColors() {
        buttonsContainerView.backgroundColor = .primary
    }
    
    func setupView() {
        buttonsContainerView.layer.cornerRadius = cornerRadius
    }
    
    func setupDuration() {
        duration = Int(dataSouce.first ?? "")
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        guard vehicle != nil else { return false }
        
        guard date != nil else { return false }
        
        guard duration != nil else { return false }
        
        return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        setupBookingController(from: segue)
    }
    
    func setupBookingController(from segue: UIStoryboardSegue) {
        
        guard let controller = segue.destination as? BookingConfirmationViewController else { return }
        
        controller.vehicle = vehicle
        controller.date = date
        controller.duration = duration
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
        duration = Int(dataSouce[row]) ?? duration
    }

}
