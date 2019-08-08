//
//  AppDelegate.swift
//  HPS_User
//
//  Created by Vamsi on 02/07/19.
//  Copyright © 2019 iOSDevelopers. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging
import SwiftyJSON
import EZSwiftExtensions


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate {

    var window: UIWindow?
    let gcmMessageIDKey       = "gcm.message_id"
    var gcmNotificationIDKey = "gcm.notification.payload"
    let KEY                                   = "action"
    let DATA                                = "data"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                TheGlobalPoolManager.instanceIDTokenMessage  = result.token
            }
        }
        self.SetInitialViewController()
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
}
extension AppDelegate{
    func SetInitialViewController(){
        if UserDefaults.standard.value(forKey:USER_INFO) != nil{
            let dic = TheGlobalPoolManager.retrieveFromDefaultsFor(USER_INFO) as! NSDictionary
            let restDetails = JSON(dic)
            ModelClassManager.loginModel = LoginModel.init(fromJson: restDetails)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller  = storyboard.instantiateViewController(withIdentifier: "HomeNavigationID") as! UINavigationController
            self.window?.rootViewController = controller
            self.window?.makeKeyAndVisible()
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller : UINavigationController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationID") as! UINavigationController
            self.window?.rootViewController = controller
            self.window?.makeKeyAndVisible()
        }
    }
}
extension AppDelegate : UNUserNotificationCenterDelegate{
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo as! [String:AnyObject]
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print("USER INFO ============",userInfo)
        if let key = userInfo[KEY] as? String{
            if key == EVENT_BOOKING_UPDATED{
                if let data = (userInfo[DATA] as? String)?.toJSON()  as? [String : AnyObject]{
                    print("Event Booking Updated",data)
                    NotificationCenter.default.post(name:NSNotification.Name(rawValue: EVENT_BOOKING_UPDATED), object: nil, userInfo: nil)
                }
            }else if key == EVENT_BOOKING_ADDED{
                if let data = (userInfo[DATA] as? String)?.toJSON()  as? [String : AnyObject]{
                    print("Event Booking Added",data)
                    NotificationCenter.default.post(name:NSNotification.Name(rawValue: EVENT_BOOKING_ADDED), object: nil, userInfo: nil)
                }
            }else if key == USER_UPDATED{
                if let data = (userInfo[DATA] as? String)?.toJSON()  as? [String : AnyObject]{
                    print("User Added",data)
                    NotificationCenter.default.post(name:NSNotification.Name(rawValue: USER_UPDATED), object: nil, userInfo: nil)
                }
            }else if key == EVENT_UPDATED{
                if let data = (userInfo[DATA] as? String)?.toJSON()  as? [String : AnyObject]{
                    print("Event Updated",data)
                    NotificationCenter.default.post(name:NSNotification.Name(rawValue: EVENT_ADDED), object: nil, userInfo: nil)
                }
            }else if key == EVENT_ADDED{
                if let data = (userInfo[DATA] as? String)?.toJSON()  as? [String : AnyObject]{
                    print("Event Added",data)
                    NotificationCenter.default.post(name:NSNotification.Name(rawValue: EVENT_ADDED), object: nil, userInfo: nil)
                }
            }
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print("222========",userInfo)
        completionHandler()
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("222",remoteMessage.appData)
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        TheGlobalPoolManager.instanceIDTokenMessage  = fcmToken
    }
}

