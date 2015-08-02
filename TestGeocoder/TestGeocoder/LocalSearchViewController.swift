//
//  LocalSearchViewController.swift
//  TestGeocoder
//
//  Created by Kosuke Matsuda on 2015/05/06.
//  Copyright (c) 2015年 Kosuke Matsuda. All rights reserved.
//

import UIKit
import MapKit

class LocalSearchViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "LocalSearch"
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

    @IBAction func tapSearch(sender: AnyObject) {
        APPLog("\(self.textField.text)")
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = self.textField.text
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response, error) -> Void in
            guard let response = response else { return }
            for item in response.mapItems {
                let placemark = item.placemark
                APPLog("name : \(placemark.name)")
                APPLog("title : \(placemark.title)")
                APPLog("latitude : \(placemark.coordinate.latitude)")
                APPLog("longitude : \(placemark.coordinate.longitude)")
            }
        }
    }

    func tapCancel() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
