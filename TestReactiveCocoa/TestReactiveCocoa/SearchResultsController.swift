//
//  SearchResultsController.swift
//  TestReactiveCocoa
//
//  Created by Kosuke Matsuda on 2015/08/26.
//  Copyright © 2015年 matsuda. All rights reserved.
//

import UIKit
import ReactiveCocoa

class SearchResultsController: UITableViewController {

    var tweets: [Tweet]? = [Tweet]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func displayTweets(tweets: [Tweet]) {
        self.tweets = tweets
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tweets?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TweetCell

        let tweet = self.tweets![indexPath.row]
        cell.statusText.text = tweet.status
        cell.usernameText.text = "@\(tweet.username)"
        cell.avatarView.image = nil

        self.signalForLoadingImage(tweet.profileImageUrl)
        .deliverOnMainThread()
            .subscribeNext { (value: AnyObject!) -> Void in
                cell.avatarView.image = value as? UIImage
            }
        return cell
    }

    func signalForLoadingImage(imageUrl: String) -> RACSignal {
        let scheduler = RACScheduler(priority: RACSchedulerPriorityBackground)

        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            if let data = NSData(contentsOfURL: NSURL(string: imageUrl)!) {
                let image = UIImage(data: data)
                subscriber.sendNext(image)
                subscriber.sendCompleted()
            }
            return nil
        }) .subscribeOn(scheduler)
    }
}
