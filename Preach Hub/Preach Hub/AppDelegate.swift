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
import CoreData
import UserNotifications
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import BRYXBanner
import Alamofire
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initialSetUp(application)
        // Setup Crashlytics for Crash Analysis
        Fabric.with([Crashlytics.self])
        
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
    
    
    // MARK: - Initial Setup
    func initialSetUp(_ application: UIApplication){
        
        //PushNotification
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM
            // Messaging.messaging() = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        UserDefaults.standard.set(0, forKey: "BadgeNumber")
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        Messaging.messaging().shouldEstablishDirectChannel = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(tokenRefreshNotification(notification:)), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
        
        Messaging.messaging().delegate = self
        
    }
    
    @objc func tokenRefreshNotification(notification: NSNotification) {
        // NOTE: It can be nil here
        let refreshedToken = InstanceID.instanceID().token()
        UserDefaults.standard.set(refreshedToken, forKey: "fcm_Token")
        
        connectToFcm()
    }
    
    func connectToFcm() {
        // Won't connect since there is no token
        guard InstanceID.instanceID().token() != nil else {
            return;
        }
        Messaging.messaging().shouldEstablishDirectChannel = true
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

    // MARK: - Core Data stack
    
        lazy var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
            let container = NSPersistentContainer(name: "PreachHub")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
    // Replace this implementation with code to handle the error appropriately.
    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    
    /*
     Typical reasons for an error here include:
     * The parent directory does not exist, cannot be created, or disallows writing.
     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
     * The device is out of space.
     * The store could not be migrated to the current model version.
     Check the error message to determine what the actual problem was.
     */
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
    
    // MARK: - Core Data Saving support
    
        func saveContext () {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
    // Replace this implementation with code to handle the error appropriately.
    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        //registerDevice()
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        UserDefaults.standard.set(InstanceID.instanceID().token(), forKey: "fcm_Token")
        let device_Token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        UserDefaults.standard.set(device_Token, forKey: "device_Token")
        Messaging.messaging().apnsToken = deviceToken
        let accessToken = UserDefaults.standard.string(forKey: "access_token")
        if(accessToken != nil){
            // FCMApiManager.shared.pushNotificationCallBack()
        }
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    // MARK: - RemoteNotification Methods
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Notification receives here when the app is in Background
        // Let FCM know about the message for analytics etc.
        Messaging.messaging().appDidReceiveMessage(userInfo)
        print(userInfo)
        if let aps = userInfo["aps"] as? [String:Any] {
            let badgeCount = aps["badge"] as! Int
            incrementBadgeNumberBy(badgeNumberIncrement: badgeCount)
        }
//        setNotificationForRequest()
    }
    
    func incrementBadgeNumberBy(badgeNumberIncrement: Int) {
        var currentBadgeNumber = 0
        let badgeNumber = UserDefaults.standard.integer(forKey: "BadgeNumber")
        if badgeNumber != 0 {
            currentBadgeNumber = badgeNumber
        }
        let updatedBadgeNumber = currentBadgeNumber + badgeNumberIncrement
        if (updatedBadgeNumber > -1) {
            UIApplication.shared.applicationIconBadgeNumber = updatedBadgeNumber
            UserDefaults.standard.set(updatedBadgeNumber, forKey: "BadgeNumber")
        }
    }
    
    func registerDevice(){
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let createdDate = dateFormatter.string(from: date)
        
       // let UUID = UIDevice.current.identifierForVendor!.uuidString
        let device = UIDevice.current
        let fcm = Messaging.messaging().fcmToken
        let memberId = UserDefaults.standard.string(forKey: "memberId")
        
        let parameters: [String: Any] = ["fcmToken": "\(fcm != nil ? String(describing: String(fcm!)) : " ")", "memberid": "\(memberId != nil ? memberId! : "")", "osType": "ios", "osVersion": device.systemVersion, "deviceName": device.name, "datecreated": createdDate]
        
        let httpHeader: HTTPHeaders = HTTPHeaders()
        let fullUrl = GlobalConstants.APIUrls.apiBaseUrl + GlobalConstants.APIUrls.registerDevice
        
        Alamofire.request(fullUrl, method: .post, parameters: parameters, headers: httpHeader).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                _ = JSON(value)
            //callback(json)
            case .failure(let error):
                Crashlytics.sharedInstance().recordError(error)
            }
        }
    }
    
    private func application(_ application: UIApplication, didRegister notificationSettings: UNNotificationSetting){
        application.registerForRemoteNotifications()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Notification receives here when the app is in Foreground
        let current = UNUserNotificationCenter.current()
        // let content = notification.request.content
        //let badgeCount = content.badge as! Int
        //UIApplication.shared.applicationIconBadgeNumber = badgeCount
        
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                // Notification permission has not been asked yet, go for it!
            }
            if settings.authorizationStatus == .denied {
                // Notification permission was previously denied, go to settings & privacy to re-enable
            }
            if settings.authorizationStatus == .authorized {
                // Notification permission was already granted
                DispatchQueue.main.async {
                    let banner = Banner(title:String(notification.request.content.title), subtitle: String(notification.request.content.body), image: UIImage(named: "notification"), backgroundColor: UIColor.gray)
                    banner.dismissesOnTap = true
                    banner.shouldTintImage = false
                    banner.textColor = UIColor.black
                    banner.show(duration: 5.0)
                }
            }
        })
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //Handle the notification
        print("did receive")
        //let body = response.notification.request.content.body
        let content = response.notification.request.content
        //let badgeCount = content.badge as! Int
        //  incrementBadgeNumberBy(badgeNumberIncrement: badgeCount)
        // UIApplication.shared.applicationIconBadgeNumber = badgeCount
        completionHandler()
        //setNotificationForRequest()
    }
    
}

