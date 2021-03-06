//
//  User.swift
//  TwitterClient
//
//  Created by Prasanthi Relangi on 2/20/16.
//  Copyright © 2016 prasanthi. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var profileBackgroundImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
    
    var followersCountIntValue: Int?
    var followersCountInK: Int?
    var followersCount: String?
    
    var followingCountIntValue: Int?
    var followingCountInK: Int?
    var followingCount: String? //friends_count in Twitter API
    
    var tweetsCountIntValue: Int?
    var tweetsCountInK: Int?
    var tweetsCount: String?
    
    //Constructor
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        profileBackgroundImageUrl = dictionary["profile_background_image_url_https"] as? String
        
        profileBackgroundImageUrl = dictionary["profile_banner_url"] as? String
        tagline = dictionary["description"] as? String
        
        followersCountIntValue = dictionary["followers_count"]! as! Int
        followersCountInK = followersCountIntValue!/1000
        //print("followersCountIntValue: \(followersCountIntValue) followersCountInK: \(followersCountInK)")
        if followersCountInK > 0 {
            followersCount = "\(followersCountInK!)K"
        }
        else {
            followersCount = "\(dictionary["followers_count"]!)"
        }
        print("followersCountIntValue: \(followersCountIntValue) followersCountInK: \(followersCountInK)")
        
        
        
        followingCountIntValue = dictionary["friends_count"]! as! Int
        followingCountInK = followingCountIntValue!/1000
        print("followingCountIntValue: \(followingCountIntValue) followingCountInK: \(followingCountInK)")
        if followingCountInK > 0 {
            followingCount = "\(followingCountInK!)K"
        }
        else {
            followingCount = "\(dictionary["friends_count"]!)"
        }
        print("followingCount: \(followingCount)")
        
        
        
        
        tweetsCountIntValue = dictionary["statuses_count"]! as! Int
        tweetsCountInK = tweetsCountIntValue!/1000
        print("tweetsCountIntValue: \(tweetsCountIntValue) tweetsCountInK: \(tweetsCountInK)")
        if tweetsCountInK > 0 {
            tweetsCount = "\(tweetsCountInK!)K"
        }
        else {
            tweetsCount = "\(dictionary["statuses_count"]!)"
        }
        print("tweetsCount: \(tweetsCount)")
        
        
        

        
        self.dictionary = dictionary
        
    }
    
    //Current User
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    do {
                        var dictionary =  try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                        _currentUser = User(dictionary: dictionary as! NSDictionary)
                    }
                    catch {
                        print("Cannot get data")
        
                    }
        
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                
                //Error handling for Swift 1.2
                do{
                    //serialize JSON data or encode data (this is a hack!)
                    var data = try NSJSONSerialization.dataWithJSONObject((user?.dictionary)!, options: [])
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                    
                    
                }
                catch {
                    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
                    
                }
                NSUserDefaults.standardUserDefaults().synchronize()
                
            }
            
        }
    }
    
    func logout() {
        //Clear the currentUser
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        //Use NSNotifications to broadcast that User logged out
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
        
    }
    
    
    func getCountInK(count: Int)-> String {
        var result = "\(count)"
        if (count/1000) > 0 {
            result = "\(count/1000)K"
        }
        
        
        return result
        
    }
    
    

}
