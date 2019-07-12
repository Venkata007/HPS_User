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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
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
