//
//  TweetsCell.swift
//  TwitterClient
//
//  Created by Prasanthi Relangi on 2/21/16.
//  Copyright © 2016 prasanthi. All rights reserved.
//

import UIKit


protocol TweetsCellDelegate {
    func tweetsCell(tweetsCell: TweetsCell, profileImageClicked: Bool?)
}

class TweetsCell: UITableViewCell {
    
    
    var delegate: TweetsCellDelegate?
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var postedTimeLabel: UILabel!

    @IBOutlet weak var tweetLabel: UILabel!
    
    
    @IBOutlet weak var favouriteCountLabel: UILabel!
    
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    
    @IBAction func onFavorite(sender: AnyObject) {
        
//        if tweet!.favorited==true {
//            tweet?.favorited = false
//        }
//        else {
//            tweet?.favorited = true
//        }
        
        print("Is this a favorite: \(tweet?.favorited) id: \(tweet?.id) favCount: \(tweet?.favouriteCount)")
        
        if(tweet?.favorited == true) {
            TwitterClient.sharedInstance.setFavorite(tweet!) { (tweet, error) -> () in
                if let tweet = tweet {
                    print("Set this tweet as a favorite; id = \(tweet.id)")
                    self.favouriteCountLabel.text = tweet.favouriteCount
                    self.favoriteButton.setImage(UIImage(named: "like-action-on"), forState: .Normal)
                    
                }
                
                
                
            }
        }
        else {
            TwitterClient.sharedInstance.deleteFavorite(tweet!, completion: { (tweet, error) -> () in
                print("Removed favorite")
                if let tweet = tweet {
                    print("Removed this tweet as a favorite; id = \(tweet.id)")
                    self.favouriteCountLabel.text = tweet.favouriteCount
                    self.favoriteButton.setImage(UIImage(named: "like-action"), forState: .Normal)
                    
                }
                //self.favoriteButton.setImage(UIImage(named: "like-action"), forState: .Normal)
            })
        }
        
    }
    
    
    @IBAction func onRetweet(sender: AnyObject) {
        if tweet?.retweeted == true {
            tweet?.retweeted = false
        }
        else {
            tweet?.retweeted = true
        }
        
        var retweetCount = Int((tweet?.retweetCount)!)
        print("1. retweetCount: \(retweetCount)")
        
        if tweet?.retweeted == true {
            print("2. Retweeting this tweet: \(tweet!.id)")
            TwitterClient.sharedInstance.retweet(tweet!, completion: { (tweet, error) -> () in
                print("Retweeting this tweet")
                if let tweet = tweet {
                    print("Retweet: id = \(tweet.id) retweetCount: \(tweet.retweetCount)")
                    retweetCount = retweetCount!+1
                    self.retweetCountLabel.text = "\(retweetCount!)"
                    tweet.retweetCount = "\(retweetCount)"
                    self.retweetButton.setImage(UIImage(named:"retweet-action-on"), forState: .Normal)
                    
                }
                
            })
        }
        else {
            print("Untweeting this tweet: \(tweet!.id)")
            TwitterClient.sharedInstance.unretweet(tweet!, completion: { (tweet, error) -> () in
                print("Untweeting this tweet")
                if let tweet = tweet {
                    print("Unretweet: id = \(tweet.id) retweetCount: \(tweet.retweetCount)")
                    retweetCount = retweetCount!-1
                    self.retweetCountLabel.text = "\(retweetCount!)"
                    
                    self.retweetCountLabel.text = tweet.retweetCount
                    tweet.retweetCount = "\(retweetCount)"
                    self.retweetButton.setImage(UIImage(named:"retweet-action"), forState: .Normal)
                    
                }
                
                if let error = error {
                    print("error: \(error)")
                }
                
            })
        }

        
        
    }
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.user?.name
            screenNameLabel.text = "@\(tweet.user!.screenname!)"
            tweetLabel.text = tweet.text
            postedTimeLabel.text = tweet.elapsedTime
            favouriteCountLabel.text = tweet.favouriteCount
            retweetCountLabel.text = tweet.retweetCount
            
            if let imageURL = tweet.user?.profileImageUrl {
                let imageURLFinal = NSURL(string: imageURL)
                profileImage.setImageWithURL(imageURLFinal!)
            }
            else {
                profileImage.image = nil
            }
            
            self.profileImage.layer.cornerRadius = 10;
            self.profileImage.clipsToBounds = true
            
            let tapGestureRecognier = UITapGestureRecognizer(target: self, action: "onTap")
            self.profileImage.addGestureRecognizer(tapGestureRecognier)
            
            
        }
    }
    
    
    func onTap() {
        print("Tell the Tweets VC that image was clicked")
        delegate?.tweetsCell(self, profileImageClicked: true)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
