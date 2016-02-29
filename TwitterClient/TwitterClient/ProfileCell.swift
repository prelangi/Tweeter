//
//  ProfileCell.swift
//  TwitterClient
//
//  Created by Prasanthi Relangi on 2/28/16.
//  Copyright © 2016 prasanthi. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenLabel: UILabel!
    
    @IBOutlet weak var tweetLabel: UILabel!
    
    @IBOutlet weak var retweetCount: UILabel!
    
    @IBOutlet weak var postedtimeLabel: UILabel!
    
    @IBOutlet weak var favoriteCount: UILabel!
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.user?.name
            screenLabel.text = "@\(tweet.user!.screenname!)"
            tweetLabel.text = tweet.text
            postedtimeLabel.text = tweet.elapsedTime
            favoriteCount.text = tweet.favouriteCount
            retweetCount.text = tweet.retweetCount
            
            if let imageURL = tweet.user?.profileImageUrl {
                let imageURLFinal = NSURL(string: imageURL)
                profileImageView.setImageWithURL(imageURLFinal!)
            }
            else {
                profileImageView.image = nil
            }
            
            self.profileImageView.layer.cornerRadius = 10;
            self.profileImageView.clipsToBounds = true
            
            
            
            
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
