//
//  MenuViewController.swift
//  TwitterClient
//
//  Created by Prasanthi Relangi on 2/27/16.
//  Copyright © 2016 prasanthi. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    private var profileNavigationViewController: UINavigationController!
    private var tweetsNavigationViewController: UINavigationController!
    private var mentionsNavigationViewController: UINavigationController!
    
    var viewControllers: [UINavigationController] = []
    var hamburgerViewController: HamburgerViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up tableview
        tableView.dataSource = self
        tableView.delegate = self
        
        //Set up VCs
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        tweetsNavigationViewController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController") as! UINavigationController
        let tweetsVC = tweetsNavigationViewController.viewControllers[0] as! TweetsViewController
        tweetsVC.mentionsView = false

        
        mentionsNavigationViewController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController") as! UINavigationController
        let mentionsVC = mentionsNavigationViewController.viewControllers[0] as! TweetsViewController
        mentionsVC.mentionsView = true
        

        profileNavigationViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController") as! UINavigationController
        
        //add all controllers
        viewControllers.append(profileNavigationViewController)
        viewControllers.append(tweetsNavigationViewController)
        viewControllers.append(mentionsNavigationViewController)
        
        
        setupUserProfile()
        
        //Set the default view controller for hamburgerVC
        hamburgerViewController.contentViewController = tweetsNavigationViewController
        
        //tweetsNavigationViewController = storyboard.instantiateViewControllerWithIdentifier(<#T##identifier: String##String#>)
        tableView.reloadData()
        
        
    }
    
    func setupUserProfile() {
        //nameLabel.text = User.currentUser?.name
        
        if let imageURL = User.currentUser?.profileImageUrl {
            print("Profile Image URL: \(imageURL)")
            let imageURLFinal = NSURL(string: imageURL)
            profileImageView.setImageWithURL(imageURLFinal!)
        }
        else {
            profileImageView.image = nil
        }
        
        self.profileImageView.layer.cornerRadius = 10;
        self.profileImageView.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath)
        let titles = ["Profile","Timeline","@Mentions"]
        cell.textLabel!.text = titles[indexPath.row]
        //cell.textLabel?.textAlignment = .Right
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
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
