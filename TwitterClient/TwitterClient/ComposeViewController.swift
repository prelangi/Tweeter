//
//  ComposeViewController.swift
//  TwitterClient
//
//  Created by Prasanthi Relangi on 2/21/16.
//  Copyright © 2016 prasanthi. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    var newTweet: Tweet?
    
    @IBOutlet weak var tweetTextView: UITextView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Setup User info
        setupUserProfile()
        
        //Set the controller as a delegate for TextView
        tweetTextView.delegate = self
        addDoneButton()
        
        //newTweet(

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupUserProfile() {
        nameLabel.text = User.currentUser?.name
        
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
        
        if let backgroundimageURL = User.currentUser?.profileBackgroundImageUrl {
            print("Background Image URL: \(backgroundimageURL)")
            let imageURLFinal = NSURL(string: backgroundimageURL)
            backgroundImageView.setImageWithURL(imageURLFinal!)
        }
        else {
            backgroundImageView.image = nil
        }
    }
    
    
    @IBAction func onTweet(sender: AnyObject) {
        
        let newTweet = Tweet()
        
        newTweet.text = tweetTextView.text
        newTweet.user = User.currentUser
        
        TwitterClient.sharedInstance.createNewTweet(newTweet) { (tweets, error) -> () in
            print("Set new tweet")
        }
        dismissViewControllerAnimated(true,completion: nil)
    }
    
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true,completion: nil)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            resignFirstResponder()
            return false
            
        }
        return true
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        //self.newTweet!.text = textView.text
        print("Received text: \(textView.text)")
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        //self.newTweet!.text = textView.text
        print("Received text: \(textView.text)")
        
        
    }
    
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done,
            target: view, action: Selector("endEditing:"))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        tweetTextView.inputAccessoryView = keyboardToolbar
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
