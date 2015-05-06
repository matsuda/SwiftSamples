//
//  GeocoderViewController.swift
//  TestGeocoder
//
//  Created by Kosuke Matsuda on 2015/05/06.
//  Copyright (c) 2015年 Kosuke Matsuda. All rights reserved.
//

import UIKit
import CoreLocation

class GeocoderViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Geocoder"
        let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "tapCancel")
        self.navigationItem.leftBarButtonItem = barButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func tapGeocoder(sender: AnyObject) {
        let address = self.textField.text
        if address.isEmpty {
            return
        }
        var geocoder = CLGeocoder()
        geocoder .geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                APPLog("\(error)")
            } else {
                APPLog("\(placemarks.count)")
                if let place = placemarks.first as? CLPlacemark {
//                    APPLog("\(place)")
                    APPLog("\(place.name)")
                    let coordinate = place.location.coordinate
                    APPLog("latitude : \(coordinate.latitude)")
                    APPLog("longitude : \(coordinate.longitude)")
                }
            }
        })
    }

    func tapCancel() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
