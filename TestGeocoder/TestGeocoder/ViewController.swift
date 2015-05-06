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
    var placemark: CLPlacemark?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "CoreLocation"
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.requestWhenInUseAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupLocationManager() -> CLLocationManager {
        APPLog()
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
//        manager.distanceFilter = kCLDistanceFilterNone
        return manager
    }

    func existCoordinate() -> Bool {
        return self.latitude != nil
    }

    func reverseGeocoder() {
        let location = CLLocation(latitude: self.latitude!, longitude: self.longitude!)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            if error == nil {
                let placemark = placemarks.first as! CLPlacemark
                self.placemark = placemark
                APPLog("name = \(placemark.name)")
                APPLog("country = \(placemark.country)")
                APPLog("administrativeArea = \(placemark.administrativeArea)")
                APPLog("subAdministrativeArea = \(placemark.subAdministrativeArea)")
                APPLog("locality = \(placemark.locality)")
                APPLog("subLocality = \(placemark.subLocality)")
                APPLog("thoroughfare = \(placemark.thoroughfare)")
                APPLog("subThoroughfare = \(placemark.subThoroughfare)")
                APPLog("region = \(placemark.region)")
                self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        })
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
//        self.tableView.reloadData()
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
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
        return 3
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 5
        case 2:
            return 1
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Coordinate"
        case 1:
            return "Reverse Geocoder"
        case 2:
            return "Geocoder"
        default:
            return ""
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "latitude"
                cell.detailTextLabel!.text = "\(self.latitude ?? 0)"
            default:
                cell.textLabel?.text = "longitude"
                cell.detailTextLabel?.text = "\(self.longitude ?? 0)"
            }
        case 1:
            let emptyString = ""
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = ""
                cell.detailTextLabel!.text = "reverseGeocoder"
            case 1:
                cell.textLabel?.text = "country"
                cell.detailTextLabel!.text = "\(self.placemark?.country ?? emptyString)"
            case 2:
                cell.textLabel?.text = "administrativeArea"
                cell.detailTextLabel!.text = "\(self.placemark?.administrativeArea ?? emptyString)"
            case 3:
                cell.textLabel?.text = "locality"
                cell.detailTextLabel!.text = "\(self.placemark?.locality ?? emptyString)"
            default:
                cell.textLabel?.text = "subLocality"
                cell.detailTextLabel!.text = "\(self.placemark?.subLocality ?? emptyString)"
            }
        case 2:
            cell.textLabel?.text = ""
            cell.detailTextLabel!.text = "Geocoder"
        default:
            break
        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                if existCoordinate() {
                    reverseGeocoder()
                }
            default:
                break
            }
        case 2:
            performSegueWithIdentifier("Geocoder", sender: self)
        default:
            break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

