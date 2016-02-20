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
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL:twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }

}
