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
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tweetViewLeftMargin: NSLayoutConstraint!
    var originalLeftMargin: CGFloat = 0
    
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
 
    @IBAction func onRetweet(sender: AnyObject) {
        
    }
    
    
    @IBAction func onFavorite(sender: AnyObject) {
        
    }
    
    
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
        setNavigationBarTitle()
        
        //Set up refresh control
        setupRefreshControl()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setNavigationBarTitle() {
        let image : UIImage = UIImage(named: "title.png")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
        
    }
    
    func setupRefreshControl() {
        // Initialize a UIRefreshControl
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Fetching new Tweets")
        self.refreshControl.addTarget(self, action: "fetchTweets", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        
    }
    
    func fetchTweets() {
        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            //print("Tweets: \(tweets)")
            for tweet in tweets! {
                print("Username: \(tweet.user!.name!)")
            }
            
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
        
    }
 

    @IBAction func onLogout(sender: AnyObject) {
        
        //Clear accessToken, fire a global notification so that AppDelegate shows the login screen
        User.currentUser?.logout()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //FIXME: Change it to 20 later
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetsCell
        cell.tweet = tweets![indexPath.row]
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        var indexPath:NSIndexPath
        var tableCell:TweetsCell
        
        if let sender = sender as? TweetsCell {
            tableCell = sender as! TweetsCell
            indexPath = tableView.indexPathForCell(tableCell)!
            
            let tweet = tweets![indexPath.row]
            let detailVC = segue.destinationViewController as! TweetDetailViewController
            detailVC.tweet = tweet
        }
        
      }
    
    //Methods for panGestureRecognizer
    
    @IBAction func onPan(sender: AnyObject) {
        
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        
        
        if sender.state == UIGestureRecognizerState.Began {
            print("Pan Gesture Recognier Started")
            originalLeftMargin = tweetViewLeftMargin.constant

            
        } else if sender.state == UIGestureRecognizerState.Changed {
            print("Pan Gesture Recognier Changed")
            menuView.hidden = false
            tweetViewLeftMargin.constant = originalLeftMargin + translation.x
        
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            print("Pan Gesture Recognier Ended")
            
            if velocity.x > 0 {
                tweetViewLeftMargin.constant = view.frame.width - 50
                
                
            }
            else {
                menuView.hidden = true
                tweetViewLeftMargin.constant = 0
            }
            
        }
        
        
    }
    

}
