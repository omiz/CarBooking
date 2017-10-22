//
//  BookingConfirmationViewController.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/19/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import UIKit

class BookingConfirmationViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //TODO: Move navigation buttons to a custom view
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var buttonsContainerStackView: UIView!
    
    @IBOutlet weak var confirmbutton: UIButton!
    @IBOutlet weak var dismissbutton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var vehicle: VehicleDetail?
    
    var date: Date?
    
    var duration: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    func prepareView() {
        
        setupBackground()
        
        setupView()
        
        setupTexts()
        
        setupColors()
    }
    
    func setupBackground() {
        imageView.load(vehicle?.image)
    }
    
    func setupTexts() {
        confirmbutton.setTitle("Confirm".localized, for: .normal)
        dismissbutton.setTitle("Dismiss".localized, for: .normal)
        backButton.setTitle("Back".localized, for: .normal)
        
        titleLabel.text = "Confirmation".localized
        
        let name = vehicle?.name ?? ""
        let date = self.date?.formatted ?? ""
        let duration = self.duration?.description ?? ""
        
        let day = self.duration ?? 0 > 1 ? "days" : "day"
        
        descriptionLabel.text = String(format: "Booking %@ for %@ %@ starting %@", name, duration, day, date)
    }
    
    func setupColors() {
        buttonsContainerView.backgroundColor = .primary
    }
    
    func setupView() {
        buttonsContainerView.layer.cornerRadius = cornerRadius
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func closeAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bookingAction(_ sender: UIButton) {
        
        guard let vehicle = vehicle else { return }
        
        let book = Booking(vehicle: vehicle)
        
        book.date = date
        
        book.duration = duration
        
        DataManager.shared.bookings.book(book).load(database: handle(database:))
    }
    
    func handle(success booking: Booking) {
        
    }
    
    func handle(failure booking: Booking) {
        
    }
    
    func handle(database booking: Booking?) {
        let alert = UIAlertController(title: "Booking success".localized,
                                      message: "Your Booking has been saved".localized,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.dismiss(animated: true)
        }))
        
        present(alert, animated: true)
    }
    
    
}
