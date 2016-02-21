//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Prasanthi Relangi on 2/20/16.
//  Copyright © 2016 prasanthi. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 500 //used only for scroll height
        tableView.reloadData()
        
        //Fetch Tweets
        fetchTweets()
        
        //Set image for Navigation Controller titleview
        let image : UIImage = UIImage(named: "title.png")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchTweets() {
        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            //print("Tweets: \(tweets)")
            for tweet in tweets! {
                print("Username: \(tweet.user!.name!)")
            }
            
            self.tableView.reloadData()
        }
        
    }
 

    @IBAction func onLogout(sender: AnyObject) {
        
        //Clear accessToken, fire a global notification so that AppDelegate shows the login screen
        User.currentUser?.logout()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //FIXME: Change it to 20 later
        if let acutalTweets = tweets {
            return 10
        }
        else {
            return 0
        }
        
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetsCell
        cell.tweet = tweets![indexPath.row]
        
        return cell
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
