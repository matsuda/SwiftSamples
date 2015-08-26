//
//  Tweet.swift
//  TestReactiveCocoa
//
//  Created by Kosuke Matsuda on 2015/08/26.
//  Copyright © 2015年 matsuda. All rights reserved.
//

import UIKit

class Tweet {
    var status: String!
    var profileImageUrl: String!
    var username: String!

    class func tweetWithStatus(status: [String: AnyObject]) -> Tweet {
        let tweet = Tweet()
        tweet.status = status["text"] as? String
        if let user: [String: AnyObject] = status["user"] as? [String: AnyObject] {
            if let url = user["profile_image_url"] as? String {
                tweet.profileImageUrl = url
            }
            if let username = user["screen_name"] as? String {
                tweet.username = username
            }
        }
        return tweet
    }
}
