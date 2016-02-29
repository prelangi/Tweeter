//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Prasanthi Relangi on 2/28/16.
//  Copyright © 2016 prasanthi. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenLabel: UILabel!
    
    @IBOutlet weak var tweetCount: UILabel!
    
    @IBOutlet weak var followingCount: UILabel!
    
    
    @IBOutlet weak var followersCount: UILabel!
    
    var tweets: [Tweet]?
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupUserProfile()
        
        fetchTweets()
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let actualTweets = tweets {
            if actualTweets.count > 20 {
                return 20
            }
            else {
                return actualTweets.count
            }
            
        }
        else {
            return 0
        }
        
        
        
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! ProfileCell
        cell.tweet = tweets![indexPath.row]
        return cell
        
        
        
    }
    
    func setupUserProfile() {
        
        if(user == nil) {
            user = User.currentUser!
            self.navigationItem.title = "Me"
        }
        else {
            self.navigationItem.title = user!.name
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
        self.tweetCount.text = user!.tweetsCount
        
        //tweetCount = User.currentUser?.
        TwitterClient.sharedInstance.userTimeline(user!) { (tweets, error) -> () in
            self.tweets = tweets
            
        }
    }
    
    func fetchTweets() {
        TwitterClient.sharedInstance.userTimeline(user!) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            
        }
    
        
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
