//
//  Tweet.swift
//  TwitterClient
//
//  Created by Prasanthi Relangi on 2/20/16.
//  Copyright © 2016 prasanthi. All rights reserved.
//

import UIKit

func stringFromTimeInterval(interval:NSTimeInterval) -> NSString {
    
    let ti = NSInteger(interval)
    
    let ms = Int((interval % 1) * 1000)
    
    let seconds = ti % 60
    let minutes = (ti / 60) % 60
    let hours = (ti / 3600)
    
    
    if hours>0 {
        return NSString(format: "%d hr",hours)
    }
    if minutes>0 {
        return NSString(format: "%d min",minutes)
    }
    if seconds>0 {
        return NSString(format: "%d sec",seconds)
    }
    return NSString(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
}

class Tweet: NSObject {

    var user: User?
    var id: Int? //required for retweet
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var elapsedTime: String?
    var favouriteCount: String?
    var retweetCount: String?
    var replyToTweetId: Int?
    var retweeted: Bool?
    var favorited: Bool?
    
    override init() {
        createdAt = NSDate()
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAtString = formatter.stringFromDate(createdAt!)
        favouriteCount = "0"
        retweetCount = "0"
        favorited = false
        
    }
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        favouriteCount = "\(dictionary["favorite_count"]!)"
        retweetCount = "\(dictionary["retweet_count"]!)"
        replyToTweetId = dictionary["in_reply_to_status_id_str"] as? Int
        retweeted = dictionary["retweeted"] as? Bool
        favorited = dictionary["favorited"] as? Bool
        
        //Date formatters are expensive; It is better to have a static member
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        //Better to have this as a lazy property so that it is converted only when we need it 
        createdAt = formatter.dateFromString(createdAtString!)
        
        let currentDate = NSDate()
        let interval = currentDate.timeIntervalSinceDate(createdAt!)
        elapsedTime = stringFromTimeInterval(interval) as String
        
        
        
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


