//
//  TweetsCell.swift
//  TwitterClient
//
//  Created by Prasanthi Relangi on 2/21/16.
//  Copyright © 2016 prasanthi. All rights reserved.
//

import UIKit

class TweetsCell: UITableViewCell {
    
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var postedTimeLabel: UILabel!

    @IBOutlet weak var tweetLabel: UILabel!
    
    
    @IBOutlet weak var favouriteCountLabel: UILabel!
    
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    
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
            
            
        }
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
