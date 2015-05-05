//
//  ViewController.swift
//  TestGeocoder
//
//  Created by Kosuke Matsuda on 2015/05/05.
//  Copyright (c) 2015年 Kosuke Matsuda. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate,
UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    lazy var locationManager: CLLocationManager! = self.setupLocationManager()
//    lazy var locationManager: CLLocationManager! = {
//        let manager = CLLocationManager()
//        manager.delegate = self
//        return manager
//    }()
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        APPLog()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.requestWhenInUseAuthorization()
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
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
//        manager.distanceFilter = kCLDistanceFilterNone
        return manager
    }

    // MARK: location manager delegate
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        APPLog("status = \(status.rawValue)")
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .Denied:
            APPLog("許可されていない")
        default:
            break
        }
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        APPLog("location : \(location)")
        APPLog("latitude : \(location.coordinate.latitude)")
        APPLog("longitude : \(location.coordinate.longitude)")
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        locationManager.stopUpdatingLocation()
        self.tableView.reloadData()
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        APPLog("error : \(error)")
        if error.domain == kCLErrorDomain {
            if CLError(rawValue: error.code) == .Denied {
                APPLog("許可されていない")
            }
        }
    }

    // MARK: UITableView datasource & delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "coordinate"
        default:
            return ""
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "latitude"
            cell.detailTextLabel!.text = "\(self.latitude ?? 0)"
        case 1:
            cell.textLabel?.text = "longitude"
            cell.detailTextLabel?.text = "\(self.longitude ?? 0)"
        default:
            cell.textLabel?.text = "gecode"
            cell.detailTextLabel!.text = ""
        }
        return cell
    }
}

