//
//  ViewController.swift
//  TestGeocoder
//
//  Created by Kosuke Matsuda on 2015/05/05.
//  Copyright (c) 2015年 Kosuke Matsuda. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    lazy var locationManager: CLLocationManager! = self.setupLocationManager()
//    lazy var locationManager: CLLocationManager! = {
//        let manager = CLLocationManager()
//        manager.delegate = self
//        return manager
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        APPLog()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapGeocoderButton(sender: AnyObject) {
        let address = "渋谷区"
        var geocoder = CLGeocoder()
        geocoder .geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                APPLog("\(error)")
            } else {
                APPLog("\(placemarks.count)")
                if let place = placemarks.first as? CLPlacemark {
                    APPLog("\(place)")
                    APPLog("\(place.name)")
                    let coordinate = place.location.coordinate
                    APPLog("latitude : \(coordinate.latitude)")
                    APPLog("longitude : \(coordinate.longitude)")
                }
            }
        })
    }

    func setupLocationManager() -> CLLocationManager {
        APPLog()
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }

    // MARK: location manager delegate
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        APPLog("location : \(location)")
        APPLog("latitude : \(location.coordinate.latitude)")
        APPLog("longitude : \(location.coordinate.longitude)")
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        APPLog("error : \(error)")
    }
}

