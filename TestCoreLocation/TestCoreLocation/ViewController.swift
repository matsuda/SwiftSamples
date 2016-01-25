//
//  ViewController.swift
//  TestCoreLocation
//
//  Created by Kosuke Matsuda on 2016/01/25.
//  Copyright © 2016年 Kosuke Matsuda. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    lazy var locationManager: CLLocationManager = self.setupLocationManager()
    var deferredUpdates = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        autorizeTrackLocation()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        stopTracking()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController {
    func sendNotificaiton(message: String) {
        let notificaiton = UILocalNotification()
        notificaiton.fireDate = NSDate(timeInterval: 10, sinceDate: NSDate())
        notificaiton.timeZone = NSTimeZone.defaultTimeZone()
        notificaiton.alertBody = message
        notificaiton.alertAction = "OK"
        UIApplication.sharedApplication().scheduleLocalNotification(notificaiton)
    }
}

// MARK: - Location

extension ViewController {
    func setupLocationManager() -> CLLocationManager {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.activityType = .Fitness
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.distanceFilter = kCLDistanceFilterNone
        return manager
    }

    /// http://nshipster.com/core-location-in-ios-8/
    func autorizeTrackLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .NotDetermined:
            locationManager.requestAlwaysAuthorization()
        case .AuthorizedAlways:
            startTracking()
        default:
            let alert = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to be notified about adorable kittens near you, please open this app's settings and set location access to 'Always'.",
                preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Open Settings", style: .Default, handler: { (action) -> Void in
                if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }))
            presentViewController(alert, animated: true, completion: nil)
        }
    }

    func startTracking() {
        locationManager.startUpdatingLocation()
    }

    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            startTracking()
        default: break
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Logger.log(__FUNCTION__)

        guard let location = locations.last else { return }
        let timestamp = location.timestamp
        let interval = timestamp.timeIntervalSinceNow
        // Log("timestamp : \(timestamp) >>> interval : \(interval)")
        guard abs(Int32(interval)) < 15 else { return }

        Logger.log("latitude : \(location.coordinate.latitude), longitude : \(location.coordinate.longitude)")
        /*
        if UIApplication.sharedApplication().applicationState == .Background {
            sendNotificaiton("\(locations.first?.coordinate.latitude) : \(locations.first?.coordinate.longitude)")
        }
        */

        /*
        if !deferredUpdates {
            let distance: CLLocationDistance = 100
            let time: NSTimeInterval = 60
            locationManager.allowDeferredLocationUpdatesUntilTraveled(distance, timeout: time)
            deferredUpdates = true
        }
        */
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        Logger.log(__FUNCTION__)
        Log("error : \(error)")
    }

    func locationManager(manager: CLLocationManager, didFinishDeferredUpdatesWithError error: NSError?) {
        Logger.log(__FUNCTION__)
        if let location = manager.location {
            Logger.log("latitude : \(location.coordinate.latitude), longitude : \(location.coordinate.longitude)")
        }
        deferredUpdates = false
        if let error = error {
            Log("error : \(error)")
        }
    }
}
