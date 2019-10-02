//
//  UPennPushNotificationService.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 3/22/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import UserNotifications

protocol UPennPushNotificationDelegate {
    func handleNotificationGUID(_ guid: String)
    func fetchingNotificationData()
}

class UPennPushNotificationService {
    
    enum ConfigurationType : Int {
        case Firebase, Manual
    }
    
    fileprivate static let DeviceTokenKey = UPennNameSpacer.makeKey("deviceTokenKey")
    fileprivate static var DeviceToken: String {
        return UserDefaults.standard.value(forKey: DeviceTokenKey) as? String ?? ""
    }
    fileprivate static var Configuration: ConfigurationType = .Firebase
    var pushNotificationDelegate: UPennPushNotificationDelegate?
    var requestService: UPennNetworkRequestService = UPennNetworkRequestService()
    
    // MARK: - Register
    
    // MARK: Manual
    func registerForPushNotifications(pushDelegate: UPennPushNotificationDelegate, application: UIApplication) {
        self.pushNotificationDelegate = pushDelegate
        UNUserNotificationCenter.current() // 1
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, error in
                
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings(application)
        }
    }
    // MARK: Firebase
//    func registerForFirebasePushNotifications(
//        application: UIApplication,
//        pushDelegate: UPennPushNotificationDelegate,
//        messageDelegate: MessagingDelegate,
//        notificationDelegate: UNUserNotificationCenterDelegate) {
//        self.pushNotificationDelegate = pushDelegate
//        Messaging.messaging().delegate = messageDelegate
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = notificationDelegate
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//        } else {
//            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//        application.registerForRemoteNotifications()
//    }
    
    // MARK: Failure
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    // MARK: - Get Settings
    
    func getNotificationSettings(_ application: UIApplication) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }
    
    // MARK: - Get Device Token
    
    func application(_ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
        ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        // Store device token to send to backend later
        UPennPushNotificationService.storeDeviceToken(token, for: .Manual)
    }
    
    // MARK: - Store Device Token
    
    static func storeDeviceToken(_ token: String, for configuration: ConfigurationType) {
        if configuration == Configuration {
            UserDefaults.standard.setValue(token, forKey: DeviceTokenKey)
        }
    }
    
    // MARK: - Send Device Token
    
    func updateBackendForPushNotifications(with username: String) {
        // TODO: Erase after Testing
    }
    
    // MARK: - Process PN
    
    // Receiving Push Notification and opening app
    // Check if launched from notification
    func handleNotificationAtLaunch(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let notificationOption = launchOptions?[.remoteNotification]

        if let notification = notificationOption as? [String: AnyObject] {
            
            /*
             * 1. Get GUID from notification
             * 2. User GUID to fetch full patient contents from network
             * 3. Create Timeline item from full patient info, and trigger Notifcation Delegate
            */
            print("APS Object:\(notification)")
           
            self.handleNotificationPayload(notification)
        }
    }
    
    /**
     Unwraps notification to extract guid to request resource from network, hydrates response into UPennTimelineItem to trigger UPennPushNotificationDelegate method
     - parameter notification: Dictionary that contains "guid" string from server
    */
    func handleNotificationPayload(_ notification: Dictionary<AnyHashable,Any>, completion:
        ((UIBackgroundFetchResult) -> Void)?=nil) {
        self.pushNotificationDelegate?.fetchingNotificationData()
        var guidStr = ""
        switch UPennPushNotificationService.Configuration {
        case .Firebase:
            /*
             Firebase Push JSON
             
             {
                 "aps" : {
                     "alert" : {
                         "body" : "great match!",
                         "title" : "Portugal vs. Denmark",
                     },
                     "badge" : 1,
                },
                 "customKey" : "customValue"
             }
             */
            guard let guid = notification["Guid"] as? String else {
                completion?(.failed)
                return
            }
            guidStr = guid
        case .Manual:
            guard
                let aps = notification["aps"] as? [String: AnyObject],
                let guid = aps["guid"] as? String else {
                    completion?(.failed)
                    return
            }
            guidStr = guid
        }
        self.pushNotificationDelegate?.handleNotificationGUID(guidStr)
    }
}

private extension UPennPushNotificationService {
    
}
