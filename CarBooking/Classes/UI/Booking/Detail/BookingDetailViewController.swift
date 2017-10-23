//
//  BookingDetailViewController.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/19/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import UIKit
import UserNotifications

class BookingDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BookingTimeDelegate, BookingDayDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var buttonsContainerStackView: UIStackView!
    @IBOutlet weak var buttonsContainerBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    
    var isDirty = false { didSet { updateActionButtons() } }
    
    var request: Request?
    
    var unEditedBooking: Booking?
    
    var booking: Booking? { didSet { reloadNotifications() } }
    
    var datePickerExtended = false
    var dayPickerExtended = false
    
    var notifications: [UNNotificationRequest] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupActionsView()
        
        setupTable()
    }
    
    func reloadNotifications() {
        notifications = []
        booking?.notification(completion: {
            self.notifications = $0
            self.tableView?.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        })
    }
    
    func setupActionsView() {
        
        let bottom = view.frame.height - buttonsContainerView.frame.origin.y - buttonsContainerView.frame.height
        
        tableView.contentInset.bottom = -bottom
        
        deleteButton.setTitle("Delete".localized, for: .normal)
        cancelButton.setTitle("Cancel".localized, for: .normal)
        updateButton.setTitle("Update".localized, for: .normal)
        notificationButton.setTitle("Add notification".localized, for: .normal)
        
        buttonsContainerView.backgroundColor = .primary
        buttonsContainerView.layer.cornerRadius = cornerRadius
        
        updateActionButtons()
    }
    
    func updateActionButtons() {
        cancelButton.isHidden = !isDirty
        updateButton.isHidden = !isDirty
        
        deleteButton.isHidden = isDirty
        notificationButton.isHidden = isDirty || (booking?.date?.timeIntervalSinceNow ?? 0) <= 0
    }

    func setupTable() {
    
        tableView.dynamicHeight(estimated: 44)
        tableView.removeExtraCells()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard booking != nil else { return 0 }
        
        var sections = 0
        
        sections += 1 // title
        sections += 1 // date
        sections += 1 // duration
        sections += 1 // notifications
        
        return sections
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard booking != nil else { return 0 }
        
        return section == 3 ? notifications.count : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 3 && !notifications.isEmpty ? "Notifications".localized : ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = .white
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return bookingTitle(in: tableView, at: indexPath)
            
        case 1:
            return bookingTimePicker(in: tableView, at: indexPath)
            
        case 2:
            return bookingDayPicker(in: tableView, at: indexPath)
            
        case 3:
            return bookingNotification(in: tableView, at: indexPath)
            
        default:
            return UITableViewCell(frame: CGRect.zero)
        }
    }
    
    func bookingTitle(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(BookingTitleCell.self, for: indexPath)
        
        cell.setup(booking)
        
        return cell
    }
    
    func bookingTimePicker(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(BookingTimePickerCell.self, for: indexPath)
        
        cell.setup(booking, delegate: self)
        
        cell.extended = datePickerExtended
        
        return cell
    }
    
    func bookingDayPicker(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(BookingDayPickerCell.self, for: indexPath)
        
        cell.setup(booking, delegate: self)
        
        cell.extended = dayPickerExtended
        
        return cell
    }
    
    func bookingNotification(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(BookingNotificationCell.self, for: indexPath)
        
        cell.setup(booking, notificationRequest: notifications[indexPath.row])
        
        return cell
    }
    
    @IBAction func deleteBooking(_ sender: UIButton) {
        
        guard let booking = booking else { return }
        
        let alert = UIAlertController(title: "Booking".localized,
                                      message: "Are you sure you want to delete this Booking?".localized,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: { _ in
            
            booking.removeAllNotifications()
            
            self.request?.cancel()
            
            self.request = DataManager.shared.bookings.delete(booking).load()
            
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "No".localized, style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    @IBAction func cancelBookingUpdate(_ sender: UIButton) {
        
        isDirty = false
        dayPickerExtended = false
        datePickerExtended = false
        
        guard let old = unEditedBooking else { return }
        
        booking = old
        unEditedBooking = nil
        
        tableView?.reloadData()
    }
    
    @IBAction func updateBooking(_ sender: UIButton) {
        guard let booking = booking else { return }
        
        self.request?.cancel()
        
        self.request = DataManager.shared.bookings.update(booking).load(database: {
            self.booking = $0
            self.tableView?.reloadData()
            self.isDirty = false
            self.unEditedBooking = nil
        })
    }
    
    @IBAction func addNotification(_ sender: UIButton) {
        guard let booking = booking else { return }
        
        guard let date = booking.date, date.timeIntervalSinceNow > 0 else { return }
        
        showNotificationDatePicker(sender)
    }
    
    func showNotificationDatePicker(_ sender: UIView) {
        let alert = UIAlertController.init(title: nil, message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        let picker = addDatePicker(in: alert)
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Set".localized, style: .default, handler: { _ in
            self.addNotification(at: picker.date)
        }))
        
        alert.popoverPresentationController?.sourceView = sender
        alert.popoverPresentationController?.sourceRect = CGRect(x: sender.bounds.midX, y: sender.bounds.midY, width: 0, height: 0)
        
        present(alert, animated: true)
    }
    
    func setup(notificationDatePicker picker: UIDatePicker) {
        
        picker.minimumDate = Date()
        picker.maximumDate = booking?.date ?? Booking.defaultDate
    }
    
    @discardableResult
    func addDatePicker(in alert: UIAlertController) -> UIDatePicker {
        
        let picker = UIDatePicker(frame: CGRect.zero)
        
        setup(notificationDatePicker: picker)
        
        alert.view.addSubview(picker)
        alert.view.clipsToBounds = true
        
        return picker
    }
    
    func addNotification(at date: Date) {
        guard let booking = booking else { return }
        
        guard booking.isBooked else { return }
        
        booking.addNotification(at: date) {
            guard $0 == nil else { return }
            self.reloadNotifications()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        updateTimePickerCellIfNeeded(tableView, at: indexPath)
        
        updateDayPickerCellIfNeeded(tableView, at: indexPath)
    }
    
    func updateTimePickerCellIfNeeded(_ tableView: UITableView, at indexPath: IndexPath) {
        
        guard let c = tableView.cellForRow(at: indexPath) else { return }
        
        guard let cell = c as? BookingTimePickerCell else { return }
        
        datePickerExtended = !datePickerExtended
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            tableView.beginUpdates()
            cell.extended = self.datePickerExtended
            tableView.endUpdates()
        })
    }
    
    func updateDayPickerCellIfNeeded(_ tableView: UITableView, at indexPath: IndexPath) {
        
        guard let c = tableView.cellForRow(at: indexPath) else { return }
        
        guard let cell = c as? BookingDayPickerCell else { return }
        
        dayPickerExtended = !dayPickerExtended
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            tableView.beginUpdates()
            cell.extended = self.dayPickerExtended
            tableView.endUpdates()
        })
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 3
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction.init(style: .destructive, title: "Delete".localized) {
            self.delete(notification: $0, at: $1)
        }
        
        return [delete]
    }
    
    func delete(notification: UITableViewRowAction, at indexPath: IndexPath) {
        
        guard let date = booking?.scheduleDate(in: notifications[indexPath.row]) else { return }
        
        booking?.removeNotification(at: date)
    }
    
    func bookingTime(changed date: Date) {
        isDirty = true
        
        unEditedBooking = unEditedBooking ?? booking
        
        booking?.date = date
    }
    
    func bookingDay(changed days: Int) {
        isDirty = true
        
        unEditedBooking = unEditedBooking ?? booking
        
        booking?.duration = days
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: segue)
        
        setupDetailIndexIfNeeded(in: segue)
    }
    
    func setupDetailIndexIfNeeded(in segue: UIStoryboardSegue) {
        
        guard let controller = segue.destination as? VehicleDetailViewController else { return }
        
        guard let vehicle = booking?.vehicle else { return }
        
        controller.vehicleId = vehicle.id
        controller.vehicle = vehicle
    }

    deinit {
        request?.cancel()
    }
}
