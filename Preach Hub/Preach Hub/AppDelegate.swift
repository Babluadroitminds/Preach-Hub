//
//  AppDelegate.swift
//  Preach Hub
//
//  Created by APPLE on 16/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        STPPaymentConfiguration.shared().publishableKey = "pk_test_odTtoLCVDmMzGQHTttRXjRQk00Md7Dppq5"
        Thread.sleep(forTimeInterval: 2.0)
        if UserDefaults.standard.bool(forKey: "Is_Logged_In") == true { // User has logged in already
            let storyboard:UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeTabBarViewController") as! HomeTabBarViewController
            let navigationController = UINavigationController(rootViewController: initialViewController)
            navigationController.isNavigationBarHidden = true
            self.window?.rootViewController = navigationController
        }
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


}

