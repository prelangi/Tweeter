//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Prasanthi Relangi on 2/19/16.
//  Copyright © 2016 prasanthi. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterBaseURL = NSURL(string: "https://api.twitter.com")
let twitterConsumerKey = "OI24sIFSH4kTU0gVB5PW0CFYB"
let twitterConsumerSecret = "vGlAaX1M2HDE2TAYE5Yu5RYyCBlmwZ1YWZ4OjD9wazCBP32Vq5"

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error:NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL:twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        //Fetch request token & redirect to authorization page
        let callbackURL = NSURL(string: "TwitterClient4CP://oauth")
        
        //TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: callbackURL, scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token \(requestToken.token)")
            let authURL = NSURL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            
        })
        { (error: NSError!) -> Void in
            print("Error")
            self.loginCompletion?(user:nil,error: error)
        }
        
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        
        //Get home_time of the user
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (task: NSURLSessionDataTask,response: AnyObject?) -> Void in
            
            print("Home timeline: \(response)")
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            for tweet in tweets {
                print("text: \(tweet.text!), created: \(tweet.createdAt!)")
            }
            completion(tweets: tweets, error: nil)
            
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error getting User(error: \(error)")
                completion(tweets: nil, error: error)
        })
        
    
    }
    
    func createNewTweet(tweet: Tweet,
        completion: (tweet: Tweet?, error: NSError?) -> ()) {
            
            let params = NSMutableDictionary()
            params["status"] = tweet.text
            
            if let replyToTweetId = tweet.replyToTweetId {
                params["in_reply_to_status_id"] = replyToTweetId
            }
            
            
            POST("1.1/statuses/update.json", parameters: params, success: {(task: NSURLSessionDataTask,response: AnyObject?) -> Void in
                let tweet = Tweet(dictionary: (response as? NSDictionary)!)
                completion(tweet: tweet, error: nil)
            },
            failure:
            { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error while posting Tweet: \(error)")
                completion(tweet: nil, error: error)
            })

    }
    
    //Add support for retweet and unretweeting
    func retweet(tweet: Tweet, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/retweet/\(tweet.id!).json",parameters: nil, success: {(task: NSURLSessionDataTask,response: AnyObject?) -> Void in
                let tweet = Tweet(dictionary: (response as? NSDictionary)!)
                tweet.retweeted = true
                completion(tweet: tweet, error: nil)
            },
            failure:
            { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error getting User(error: \(error)")
                completion(tweet: nil, error: error)
            }
        )

        
    }
    
    func unretweet(tweet: Tweet, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/unretweet/\(tweet.id!).json",parameters: nil, success: {(task: NSURLSessionDataTask,response: AnyObject?) -> Void in
            let tweet = Tweet(dictionary: (response as? NSDictionary)!)
            tweet.retweeted = false
            completion(tweet: tweet, error: nil)
            },
            failure:
            { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error getting User(error: \(error)")
                completion(tweet: nil, error: error)
            }
        )
        
        
    }
    
    //Add support for favoriting and unfavoriting
    func setFavorite(tweet: Tweet, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        let params = NSMutableDictionary()
        params["id"] = tweet.id
        
        POST("1.1/favorites/create.json",parameters: params, success: {(task: NSURLSessionDataTask,response: AnyObject?) -> Void in
            let tweet = Tweet(dictionary: (response as? NSDictionary)!)
            tweet.favorited = true
            completion(tweet: tweet, error: nil)
            },
            failure:
            { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error getting User(error: \(error)")
                completion(tweet: nil, error: error)
            }
        )
    }
    
    func deleteFavorite(tweet: Tweet, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        let params = NSMutableDictionary()
        params["id"] = tweet.id
        
        POST("1.1/favorites/destroy.json",parameters: params, success: {(task: NSURLSessionDataTask,response: AnyObject?) -> Void in
            let tweet = Tweet(dictionary: (response as? NSDictionary)!)
            tweet.favorited = false
            completion(tweet: tweet, error: nil)
            },
            failure:
            { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error getting User(error: \(error)")
                completion(tweet: nil, error: error)
            }
        )
    }
    
    
    func openURL(url: NSURL) {
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken:BDBOAuth1Credential!) -> Void in
            print("Got access token")
            
            //Save the access token received in the URL
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            //Find the current user
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (task: NSURLSessionDataTask,response: AnyObject?) -> Void in
                print("User: \(response)")
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print("Username: \(user.name)")
                self.loginCompletion?(user:user,error:nil)
                
                }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                    print("Error getting User")
            })
            
            
            
            
        })
        { (error: NSError!) -> Void in
            print("Got error")
            self.loginCompletion?(user:nil, error:error)
        }

        
    }

}
