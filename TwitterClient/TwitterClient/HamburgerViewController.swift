//
//  HamburgerViewController.swift
//  TwitterClient
//
//  Created by Prasanthi Relangi on 2/27/16.
//  Copyright © 2016 prasanthi. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    @IBOutlet weak var contentLeftMargin: NSLayoutConstraint!
    var originalLeftMargin: CGFloat = 0
    
    var contentViewController:UIViewController! {
        didSet {
            view.layoutIfNeeded()
            
            contentView.addSubview(contentViewController.view)
            
            //Once contentView is set; make it occupy the whole screen
            UIView.animateWithDuration(0.3) { () -> Void in
                self.contentLeftMargin.constant = 0
                self.view.layoutIfNeeded()
            }
            
        }
    }
        
    
    var menuViewController:MenuViewController! {
        didSet {
            //Lazy property will call view hierarchy so that viewDidLoad, viewDidAppear will be called
            view.layoutIfNeeded()
            
            menuView.addSubview(menuViewController.view)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("In hamburger view controller")

        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

    @IBAction func onPan(sender: AnyObject) {
        
        let translation = panGestureRecognizer.translationInView(view)
        let velocity = panGestureRecognizer.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            print("Pan started")
            originalLeftMargin = contentLeftMargin.constant
            

            
        } else if sender.state == UIGestureRecognizerState.Changed {
            print("Pan Changing...")
            contentLeftMargin.constant = originalLeftMargin + translation.x
        
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            print("Pan ended")
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                if velocity.x > 0 {
                    self.contentLeftMargin.constant = self.view.frame.width*0.5
                }
                else {
                    self.contentLeftMargin.constant = 0
                }

            })
            
        }
    }
}
