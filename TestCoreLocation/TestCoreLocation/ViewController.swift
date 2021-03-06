//
//  ViewController.swift
//  TestCoreLocation
//
//  Created by Kosuke Matsuda on 2016/01/25.
//  Copyright © 2016年 Kosuke Matsuda. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion

class ViewController: UIViewController {

    lazy var locationManager: CLLocationManager = self.setupLocationManager()
    var deferredUpdates = false
    let motionManager = CMMotionActivityManager()

    @IBOutlet weak var form1: UIView!
    @IBOutlet weak var form2: UIView!
    @IBOutlet weak var form3: UIView!
    @IBOutlet weak var form4: UIView!
    @IBOutlet weak var form5: UIView!
    @IBOutlet weak var form6: UIView!
    @IBOutlet weak var form7: UIView!
    @IBOutlet weak var form8: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        prepareViews()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        autorizeTrackLocation()
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivity()
        } else {
            let alert = UIAlertController(title: "", message: "Motion Activity isn't available", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        stopTrackingActivity()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func prepareViews() {
        if let label = form1.viewWithTag(1) as? UILabel {
            label.text = "startDate"
        }
        if let label = form2.viewWithTag(1) as? UILabel {
            label.text = "confidence"
        }
        if let label = form3.viewWithTag(1) as? UILabel {
            label.text = "stationary"
        }
        if let label = form4.viewWithTag(1) as? UILabel {
            label.text = "walking"
        }
        if let label = form5.viewWithTag(1) as? UILabel {
            label.text = "running"
        }
        if let label = form6.viewWithTag(1) as? UILabel {
            label.text = "automotive"
        }
        if let label = form7.viewWithTag(1) as? UILabel {
            label.text = "cycling"
        }
        if let label = form8.viewWithTag(1) as? UILabel {
            label.text = "unknown"
        }
    }

    func updateViewsForActivity(activity: CMMotionActivity) {
        if let label = form1.viewWithTag(2) as? UILabel {
            label.text = "\(activity.startDate)"
        }
        if let label = form2.viewWithTag(2) as? UILabel {
            var text: String!
            switch activity.confidence {
            case .High:
                text = "High"
            case .Medium:
                text = "Medium"
            case .Low:
                text = "Low"
            }
            label.text = text
        }
        if let label = form3.viewWithTag(2) as? UILabel {
            label.text = "\(activity.stationary)"
        }
        if let label = form4.viewWithTag(2) as? UILabel {
            label.text = "\(activity.walking)"
        }
        if let label = form5.viewWithTag(2) as? UILabel {
            label.text = "\(activity.running)"
        }
        if let label = form6.viewWithTag(2) as? UILabel {
            label.text = "\(activity.automotive)"
        }
        if let label = form7.viewWithTag(2) as? UILabel {
            label.text = "\(activity.cycling)"
        }
        if let label = form8.viewWithTag(2) as? UILabel {
            label.text = "\(activity.unknown)"
        }
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
            startTrackingLocation()
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

    func startTrackingLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            return
        }
    }

    func stopTrackingLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            locationManager.stopUpdatingLocation()
        default:
            return
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            startTrackingLocation()
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
        if UIApplication.sharedApplication().applicationState == .Background {
            sendNotificaiton("\(locations.first?.coordinate.latitude) : \(locations.first?.coordinate.longitude)")
        }

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
        Logger.log("error : \(error)")
    }

    func locationManager(manager: CLLocationManager, didFinishDeferredUpdatesWithError error: NSError?) {
        Logger.log(__FUNCTION__)
        if let location = manager.location {
            Logger.log("latitude : \(location.coordinate.latitude), longitude : \(location.coordinate.longitude)")
        }
        deferredUpdates = false
        if let error = error {
            Logger.log("error : \(error)")
        }
    }
}

/*
// MARK: - CoreMotion
*/

extension ViewController {
    func startTrackingActivity() {
        guard CMMotionActivityManager.isActivityAvailable() else {
            return
        }

        motionManager.startActivityUpdatesToQueue(NSOperationQueue.mainQueue()) { [unowned self] (activity: CMMotionActivity?) -> Void in
            Logger.log("startActivityUpdatesToQueue")
            guard let activity = activity else { return }
            Logger.log("activity : \(activity)")
            self.updateViewsForActivity(activity)
            /*
            if activity.running {
                self.sendNotificaiton("running")
            }
            */
        }
    }

    func stopTrackingActivity() {
        guard CMMotionActivityManager.isActivityAvailable() else {
            return
        }

        motionManager.stopActivityUpdates()
    }
}
