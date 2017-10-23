//
//  Booking.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/18/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import Foundation
import SwiftyJSON
import TRON
import UserNotifications

class Booking: NSObject, NSCoding, BaseObject {
    
    class var notificationId: String {
        return "Booking"
    }
    
    class var defaultDate: Date {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        
        let calendar = Calendar(identifier: .gregorian)
        
        return calendar.date(bySettingHour: 9, minute: 0, second: 0, of: tomorrow) ?? Date()
    }
    
    class var allowedDaysCount: [Int] {
        return (1...7).map({ $0 })
    }
    
    var notificationId: String {
        return Booking.notificationId + "-" + id.description + "-"
    }
    
    var id: Int = 0
    
    var vehicle: VehicleDetail?
    
    var date: Date?
    
    var duration: Int?
    
    var isBooked: Bool { return date != nil }
    
    var localizedDescription: String {
        
        //TODO: update booking description for empty values
        
        let name = vehicle?.name ?? ""
        let date = self.date?.formatted ?? ""
        let duration = self.duration?.description ?? ""
        
        let day = self.duration ?? 0 > 1 ? "days".localized : "day".localized
        
        return String(format: "Booking %@ for %@ %@ starting %@".localized, name, duration, day, date)
    }
    
    var notificationStartDescription: String {
        
        //TODO: update booking description for empty values
        
        let name = vehicle?.name ?? ""
        
        return String(format: "Your booking of %@ has started".localized, name)
    }
    
    override var description: String {
        return ["id": id,
                "vehicle": vehicle?.description ?? "Not set",
                "date": date?.description ?? "Not set"].description
    }
    
    override init() { super.init() }
    
    init(vehicle: VehicleDetail) {
        super.init()
        self.vehicle = vehicle
    }
    
    required init(json: JSON) throws {
        id = json["id"].intValue
        vehicle = try VehicleDetail(json: json["vehicle"])
        
        let timestamp = json["date"].double
        
        if let timestamp = timestamp {
            date = Date(timeIntervalSince1970: timestamp)
        }
        
        let duration = json["duration"].int
        
        if let duration = duration {
            self.duration = duration
        }
    }
    
    required init(coder decoder: NSCoder) {
        id = decoder.decodeInteger(forKey: "id")
        vehicle = decoder.decodeObject(forKey: "vehicle")  as? VehicleDetail
        date = decoder.decodeObject(forKey: "date") as? Date
        duration = decoder.decodeObject(forKey: "duration") as? Int
    }
    
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(vehicle, forKey: "vehicle")
        coder.encode(date, forKey: "date")
        coder.encode(duration, forKey: "duration")
    }
    
    func updateNotificationIfNeeded() {
        notification {
            let ids = $0.map({ $0.identifier })
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
            
            $0.forEach({ self.reschedule($0) })
        }
    }
    
    func removeAllNotifications() {
        notification {
            let ids = $0.map({ $0.identifier })
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
        }
    }
    
    func notification(completion: @escaping (([UNNotificationRequest]) -> Void)) {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests {
            
            completion($0.filter({ $0.identifier.starts(with: self.notificationId) }))
        }
    }
    
    func reschedule(_ request: UNNotificationRequest) {
        
        var date = scheduleDate(in: request)
        let bookingDate = self.bookingDate(in: request)
        
        let differnce = self.date?.timeIntervalSince(bookingDate) ?? 0
        
        date = date.addingTimeInterval(differnce)
        
        addNotification(at: date)
    }
    
    func scheduleDate(in request: UNNotificationRequest) -> Date {
        let since1970 = request.content.userInfo["timeIntervalSince1970"] as? Double ?? 0
        
        return Date(timeIntervalSince1970: since1970)
    }
    
    func bookingDate(in request: UNNotificationRequest) -> Date {
        let sinceDate = request.content.userInfo["timeIntervalSinceDate"] as? Double ?? 0
        
        let date = scheduleDate(in: request)
        
        return date.addingTimeInterval(sinceDate)
    }
    
    func notificationContent(forDate date:Date) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        
        content.categoryIdentifier = typeName(self)
        content.badge = 1
        content.sound = .default()
        content.title = "Booking".localized
        content.subtitle = notificationStartDescription
        content.userInfo = ["id": self.id,
                            "timeIntervalSince1970": date.timeIntervalSince1970,
                            "timeIntervalSinceDate": self.date?.timeIntervalSince(date) ?? 0]
        
        return content
    }
    
    func addNotification(at date: Date, completion: ((Error?) -> Void)? = nil) {
        
        let content = notificationContent(forDate: date)
        
        let flags: Set<Calendar.Component> = [.timeZone, .second, .minute, .hour, .day, .month, .year]
        
        let components = Calendar.current.dateComponents(flags, from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: notificationId + date.description,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) {
            guard $0 && $1 == nil else { return }
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { completion?($0) })
        }
    }
    
    func removeNotification(at date: Date) {
        
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [notificationId + date.description])
    }
    
    static func ==(_ lhs: Booking, _ rhs: Booking) -> Bool {
        return lhs.id == rhs.id
    }
}

