//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Prasanthi Relangi on 2/28/16.
//  Copyright © 2016 prasanthi. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenLabel: UILabel!
    
    @IBOutlet weak var tweetCount: UILabel!
    
    @IBOutlet weak var followingCount: UILabel!
    
    
    @IBOutlet weak var followersCount: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUserProfile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUserProfile() {
        
        if(user == nil) {
            user = User.currentUser!
        }
        
        nameLabel.text = user!.name
        screenLabel.text = user!.screenname
        
        if let imageURL = user!.profileImageUrl {
            print("Profile Image URL: \(imageURL)")
            let imageURLFinal = NSURL(string: imageURL)
            profileImageView.setImageWithURL(imageURLFinal!)
        }
        else {
            profileImageView.image = nil
        }
        
        self.profileImageView.layer.cornerRadius = 10;
        self.profileImageView.clipsToBounds = true
        
        if let backgroundimageURL = user!.profileBackgroundImageUrl {
            print("Background Image URL: \(backgroundimageURL)")
            let imageURLFinal = NSURL(string: backgroundimageURL)
            backgroundImageView.setImageWithURL(imageURLFinal!)
        }
        else {
            backgroundImageView.image = nil
        }
        
        self.followingCount.text = user!.followingCount
        self.followersCount.text = user!.followersCount
        
        //tweetCount = User.currentUser?.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
