//
//  GoogleGeocodingViewController.swift
//  TestGeocoder
//
//  Created by Kosuke Matsuda on 2015/05/07.
//  Copyright (c) 2015年 Kosuke Matsuda. All rights reserved.
//

import UIKit

class GoogleGeocodingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var placemarks: [String: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Google API"
        let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "tapCancel")
        self.navigationItem.leftBarButtonItem = barButton
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.searchBar.becomeFirstResponder()
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

    func requestGeocoder(address: String) {
        if address.isEmpty {
            return
        }
        let geocoder = GoogleGeocoder()
        geocoder.locationByWord(address, completion: { (placemarks, error) -> Void in
            APPLog("placemarks : \(placemarks)")
        })
    }

    func tapCancel() {
        self.searchBar.resignFirstResponder()
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placemarks.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
//        let placemark = self.placemarks[indexPath.row]
//        cell.textLabel?.text = "\(placemark.administrativeArea)"
//        let coordinate = placemark.location.coordinate
//        cell.textLabel?.text = "\(placemark.locality), \(placemark.administrativeArea)"
//        cell.detailTextLabel?.text = "\(placemark.country)"
        return cell
    }

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        APPLog()
        self.searchBar.resignFirstResponder()
    }

    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        APPLog()
        searchBar.showsCancelButton = true
        return true
    }

//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        APPLog("\(searchText)")
//    }

    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        APPLog("\(searchBar.text)")
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        APPLog()
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        if let text = searchBar.text {
            requestGeocoder(text)
        }
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        APPLog()
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
//        searchBar.text = ""
    }
}
