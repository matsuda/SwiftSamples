//
//  TwitterSearchController.swift
//  TestReactiveCocoa
//
//  Created by Kosuke Matsuda on 2015/08/25.
//  Copyright © 2015年 matsuda. All rights reserved.
//

import UIKit
import Accounts
import Social
import ReactiveCocoa
import LinqToObjectiveC

class TwitterSearchController: UIViewController {

    @IBOutlet weak var textField: UITextField!

    enum TwitterInstantError: Int {
        case AccessDenied, NoTwitterAccounts, InvalidResponse
    }

    let TwitterInstantDomain = "TwitterInstant"

    var accountStore = ACAccountStore()
    lazy var twitterAccountType: ACAccountType = {
        self.accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    }()

    var tweets: [Tweet]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        reactTextField()
        requestAccessToTwitter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showResults" {
            let destination = segue.destinationViewController as! SearchResultsController
            destination.tweets = self.tweets
        }
    }

    func reactTextField() {
        textField.rac_textSignal()
            .map { (value: AnyObject!) -> AnyObject! in
                return self.isValidSearchText(value as! String) ? UIColor.whiteColor() : UIColor.yellowColor()
            }
            .subscribeNext { [weak self] (value: AnyObject!) -> Void in
                if let strongSelf = self {
                    strongSelf.textField.backgroundColor = value as? UIColor
                }
            }
    }

    func requestAccessToTwitter() {
        self.requestAccessToTwitterSignal()
            .then { [weak self] () -> RACSignal! in
                if let strongSelf = self {
                    return strongSelf.textField.rac_textSignal()
                }
                return nil
            }
            .filter { [weak self] (value: AnyObject!) -> Bool in
                if let strongSelf = self {
                    return strongSelf.isValidSearchText(value as! String)
                }
                return false
            }
            .throttle(0.5)
            .flattenMap { [weak self] (value: AnyObject!) -> RACStream! in
                if let strongSelf = self {
                    return strongSelf.signalForSearchWithText(value as! String)
                }
                return nil
            }
            .deliverOnMainThread()
            .subscribeNext({ [weak self] (value: AnyObject!) -> Void in
//                print(value)
                guard let strongSelf = self else { return }
                guard let jsonSearchResult = value as? [String: AnyObject] else { return }
                guard let statuses = jsonSearchResult["statuses"] as? [AnyObject] else { return }

                let tweets = (statuses as NSArray).linq_select { (value: AnyObject!) -> AnyObject! in
                    return Tweet.tweetWithStatus(value as! [String: AnyObject])
                }
                strongSelf.tweets = tweets as? [Tweet]
                strongSelf.performSegueWithIdentifier("showResults", sender: self)
                strongSelf.textField.text = ""
            }) { (error: NSError!) -> Void in
                print("An error occurred: \(error)")
            }
    }

    func isValidSearchText(text: String) -> Bool {
        return text.characters.count > 2
    }

    func requestAccessToTwitterSignal() -> RACSignal {
        let accessError = NSError(domain: TwitterInstantDomain, code: TwitterInstantError.AccessDenied.rawValue, userInfo: nil)

        return RACSignal.createSignal { [weak self] (subscriber: RACSubscriber!) -> RACDisposable! in
            if let strongSelf = self {
                strongSelf.accountStore.requestAccessToAccountsWithType(strongSelf.twitterAccountType, options: nil, completion: { (granted: Bool, error: NSError!) -> Void in
                    if granted {
                        subscriber.sendNext(nil)
                        subscriber.sendCompleted()
                    } else {
                        subscriber.sendError(accessError)
                    }
                })
            }
            return nil
        }
    }

    func requestforTwitterSearchWithText(text: String) -> SLRequest {
        let url = NSURL(string: "https://api.twitter.com/1.1/search/tweets.json")
        let params = ["q": text]
        return SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: params)
    }

    func signalForSearchWithText(text: String) -> RACSignal {
        let noAccountsError = NSError(domain: TwitterInstantDomain, code: TwitterInstantError.NoTwitterAccounts.rawValue, userInfo: nil)
        let invalidResponseError = NSError(domain: TwitterInstantDomain, code: TwitterInstantError.InvalidResponse.rawValue, userInfo: nil)

        return RACSignal.createSignal { (subscriber: RACSubscriber!) -> RACDisposable! in
            let request = self.requestforTwitterSearchWithText(text)
            let accounts = self.accountStore.accountsWithAccountType(self.twitterAccountType)
            if accounts.count == 0 {
                subscriber.sendError(noAccountsError)
            } else {
                request.account = accounts.last as! ACAccount
                request.performRequestWithHandler { (responseData: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) -> Void in
                    if let error = error {
                        subscriber.sendError(error)
                    } else {
                        if urlResponse.statusCode == 200 {
                            do {
                                let timelineData = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)
                                subscriber.sendNext(timelineData)
                                subscriber.sendCompleted()
                            } catch let error as NSError {
                                subscriber.sendError(error)
                            }
                        } else {
                            subscriber.sendError(invalidResponseError)
                        }
                    }
                }
            }
            return nil
        }
    }
}
