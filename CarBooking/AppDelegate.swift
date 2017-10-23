//
//  AppDelegate.swift
//  CarBooking
//
//  Created by Omar Allaham on 10/18/17.
//  Copyright © 2017 Omar Allaham. All rights reserved.
//

import UIKit
import Reachability
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    let reachability = Reachability()
    
    var  internetAlert: UIAlertController?
    
    var tabBarController: TabBarController? {
        return window?.rootViewController as? TabBarController
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        ThemeManager.apply()
        
        setupReachability()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        guard response.notification.request.content.categoryIdentifier.starts(with: Booking.notificationId) else { return completionHandler() }
        
        UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber - 1
        
        let userInfo = response.notification.request.content.userInfo
        
        guard let id = userInfo["id"] as? Int else { return completionHandler() }
        
        goToBookingDetail(with: id)
        
        completionHandler()
    }
    
    func goToBookingDetail(with id: Int) {
        let item = tabBarController?.viewControllers?.enumerated().first(where: {
            guard let controller = $0.element as? UINavigationController else { return false }
            
            return controller.viewControllers.first is BookedVehiclesViewController
        })
        
        (item?.element as? UINavigationController)?.popToRootViewController(animated: true)
        
        let index = item?.offset ?? 0
        let controller = item?.element.childViewControllers.first as? BookedVehiclesViewController
        
        tabBarController?.selectedIndex = index
        
        let booking = controller?.dataSource.enumerated().first(where: { $0.element.id == id })
        
        if let booking = booking {
            controller?.showDetail(for: booking.element.id)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
    }

    func setupReachability() {
        
        guard let reachability = reachability else { return }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: .reachabilityChanged, object: reachability)
        
        try? reachability.startNotifier()
    }

    @objc func reachabilityChanged(_ notification: Notification) {
        
        guard let reachability = notification.object as? Reachability else { return }
        
        switch reachability.connection {
        case .wifi:
            reachableInternet()
        case .cellular:
            reachableInternet()
        case .none:
            alertNoInternet()
        }
    }
    
    func alertNoInternet() {
        let alert = UIAlertController.init(title: "Alert".localized,
                                           message: "Internet is lost.\nPlease check your internet connection!".localized, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "Ok".localized, style: .default, handler: nil))
        
        window?.rootViewController?.present(alert, animated: true, completion: {
            self.internetAlert = alert
        })
    }
    
    func reachableInternet() {
        internetAlert?.dismiss(animated: true)
    }
}

