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
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var elapsedTime: String?
    var favouriteCount: String?
    var retweetCount: String?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        favouriteCount = "\(dictionary["favorite_count"]!)"
        retweetCount = "\(dictionary["retweet_count"]!)"
        
        
        //Date formatters are expensive; It is better to have a static member
        var formatter = NSDateFormatter()
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


