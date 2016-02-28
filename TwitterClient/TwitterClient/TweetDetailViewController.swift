//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Prasanthi Relangi on 2/21/16.
//  Copyright © 2016 prasanthi. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var profileBackgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var tweetLabel: UILabel!
    
    @IBOutlet weak var createdAtLabel: UILabel!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var retweetCount: Int = 0
    
    
    
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpTweetView()
        retweetCount = Int((tweet?.retweetCount)!)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpTweetView() {
        nameLabel.text = tweet!.user?.name
        screenNameLabel.text = "@\(tweet!.user!.screenname!)"
        createdAtLabel.text = tweet?.createdAtString
        retweetCountLabel.text = tweet?.retweetCount
        favoriteCountLabel.text = tweet?.favouriteCount
        tweetLabel.text = tweet?.text
        
        if let backgroundimageURL = tweet?.user!.profileBackgroundImageUrl {
            print("Background Image URL: \(backgroundimageURL)")
            let imageURLFinal = NSURL(string: backgroundimageURL)
            profileBackgroundImageView.setImageWithURL(imageURLFinal!)
        }
        else {
            profileBackgroundImageView.image = nil
        }
        
        if let imageURL = tweet!.user?.profileImageUrl {
            print("imageURL: \(imageURL)")
            let imageURLFinal = NSURL(string: imageURL)
            profileImageView.setImageWithURL(imageURLFinal!)
        }
        else {
            profileImageView.image = nil
        }
        self.profileImageView.layer.cornerRadius = 10;
        self.profileImageView.clipsToBounds = true
        
        self.retweetCount = Int((tweet?.retweetCount)!)!
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func onReply(sender: AnyObject) {
        let newTweet = Tweet()
        newTweet.replyToTweetId = tweet?.id
        newTweet.user = tweet?.user
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nvc = storyboard.instantiateViewControllerWithIdentifier("ComposeNavigationController") as! UINavigationController
        let vcs = nvc.viewControllers
        let vc = vcs[0] as! ComposeViewController
        vc.newTweet = newTweet
        
        
        //
        self.presentViewController(nvc, animated: true) { () -> Void in
            print("replying to this tweet...")
        }
        
        
        
        
        
        
    }
    
    
    
    
    @IBAction func onRetweet(sender: AnyObject) {
        
        if tweet?.retweeted == true {
            tweet?.retweeted = false
        }
        else {
            tweet?.retweeted = true
        }
        
        
        
        
        if tweet?.retweeted == true {
            print("Retweeting this tweet: \(tweet!.id) count: \(retweetCount)")
            //retweetCount = Int((tweet?.retweetCount)!)!
            TwitterClient.sharedInstance.retweet(tweet!, completion: { (tweet, error) -> () in
                print("Retweeting this tweet")
                if let tweet = tweet {
                    print("Retweet: id = \(tweet.id) retweetCount: \(tweet.retweetCount)")
                    self.retweetCount = self.retweetCount+1
                    print("After retweet: id = \(tweet.id) retweetCount: \(tweet.retweetCount)")
                    self.retweetCountLabel.text = "\(self.retweetCount)"
                    self.retweetButton.setImage(UIImage(named:"retweet-action-on"), forState: .Normal)
                    
                }
                
            })
        }
        else {
            print("Untweeting this tweet: \(tweet!.id)")
            //retweetCount = Int((tweet?.retweetCount)!)!
            TwitterClient.sharedInstance.unretweet(tweet!, completion: { (tweet, error) -> () in
                print("Untweeting this tweet")
                
                if let tweet = tweet {
                    print("Unretweet: id = \(tweet.id) retweetCount: \(self.retweetCount)")
                    self.retweetCount = self.retweetCount-1
                    print("After untweet: id = \(tweet.id) retweetCount: \(self.retweetCount)")
                    self.retweetCountLabel.text = "\(self.retweetCount)"
                    self.retweetButton.setImage(UIImage(named:"retweet-action"), forState: .Normal)
                    
                }
                
                if let error = error {
                    print("error: \(error)")
                }
                
            })
        }
        
        
    }
    
    
    @IBAction func onFavorite(sender: AnyObject) {
        
        
        if tweet!.favorited==true {
            tweet?.favorited = false
        }
        else {
            tweet?.favorited = true
        }
        
        print("Is this a favorite: \(tweet?.favorited) id: \(tweet?.id) favCount: \(tweet?.favouriteCount)")
        
        if(tweet?.favorited == true) {
            TwitterClient.sharedInstance.setFavorite(tweet!) { (tweet, error) -> () in
                if let tweet = tweet {
                    print("Set this tweet as a favorite; id = \(tweet.id)")
                    self.favoriteCountLabel.text = tweet.favouriteCount
                    self.favoriteButton.setImage(UIImage(named: "like-action-on"), forState: .Normal)
                    
                }
                
                
                
            }
        }
        else {
            TwitterClient.sharedInstance.deleteFavorite(tweet!, completion: { (tweet, error) -> () in
                print("Removed favorite")
                if let tweet = tweet {
                    print("Removed this tweet as a favorite; id = \(tweet.id)")
                    self.favoriteCountLabel.text = tweet.favouriteCount
                    self.favoriteButton.setImage(UIImage(named: "like-action"), forState: .Normal)
                    
                }
                //self.favoriteButton.setImage(UIImage(named: "like-action"), forState: .Normal)
            })
        }
        
        
        
        
    }

}
