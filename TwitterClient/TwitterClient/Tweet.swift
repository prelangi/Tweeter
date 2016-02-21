//
//  Tweet.swift
//  TwitterClient
//
//  Created by Prasanthi Relangi on 2/20/16.
//  Copyright © 2016 prasanthi. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        
        //Date formatters are expensive; It is better to have a static member
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        //Better to have this as a lazy property so that it is converted only when we need it 
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    //Class function to return all tweets as an array
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        //empty array
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
    
}
