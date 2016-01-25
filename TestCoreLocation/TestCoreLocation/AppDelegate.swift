//
//  AppDelegate.swift
//  TestCoreLocation
//
//  Created by Kosuke Matsuda on 2016/01/25.
//  Copyright © 2016年 Kosuke Matsuda. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var locationViewController: ViewController {
        return self.window?.rootViewController as! ViewController
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Logger.log("logging start! @ \(NSDate())")

        if launchOptions?[UIApplicationLaunchOptionsLocationKey] != nil {
            Logger.log("significantLocationChangeMonitoring received!!!")
            let controller = locationViewController
            controller.locationManager.startUpdatingLocation()
        }

        applicationWillRegisterForRemoteNotifications(application)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        Logger.log(__FUNCTION__)
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Logger.log(__FUNCTION__)

        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                let controller = locationViewController
                controller.locationManager.stopUpdatingLocation()
                if CLLocationManager.significantLocationChangeMonitoringAvailable() {
                    controller.locationManager.startMonitoringSignificantLocationChanges()
                }
            default: break
            }
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        Logger.log(__FUNCTION__)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        Logger.log(__FUNCTION__)

        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                let controller = locationViewController
                if CLLocationManager.significantLocationChangeMonitoringAvailable() {
                    controller.locationManager.stopMonitoringSignificantLocationChanges()
                }
                controller.locationManager.startUpdatingLocation()
            default: break
            }
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

// MARK: - APNs

extension AppDelegate {
    func applicationWillRegisterForRemoteNotifications(application: UIApplication) {
        let types: UIUserNotificationType = [.Badge, .Alert, .Sound]
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }

    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
    }
}
