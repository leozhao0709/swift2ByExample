//
//  UserImageDetailViewController.swift
//  pragmaticTweets
//
//  Created by Lei Zhao on 6/4/16.
//  Copyright © 2016 Lei Zhao. All rights reserved.
//

import UIKit

class UserImageDetailViewController: UIViewController {
    
    
    var userImageURL: NSURL?
    var perGestureTransform: CGAffineTransform?

    @IBOutlet weak var userImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userImageURL = self.userImageURL,
            imageData = NSData(contentsOfURL: userImageURL) {
            userImageView.image = UIImage(data: imageData)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        if let userImageURL = self.userImageURL,
//            imageData = NSData(contentsOfURL: userImageURL) {
//            userImageView.image = UIImage(data: imageData)
//        }
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //move image view
    @IBAction func handlePanGesture(sender: UIPanGestureRecognizer) {
        if sender.state == .Began {
            perGestureTransform = userImageView.transform
        }
        
        if sender.state == .Began || sender.state == .Changed {
            let translation = sender.translationInView(userImageView)
            let translatedTransform = CGAffineTransformTranslate(perGestureTransform!, translation.x, translation.y)
            userImageView.transform = translatedTransform
        }
    }
    
    //reset image to initial position
    @IBAction func handleDoubleTapGesture(sender: UITapGestureRecognizer) {
        userImageView.transform = CGAffineTransformIdentity
    }
    
    @IBAction func handlePinchGesture(sender: UIPinchGestureRecognizer) {
        if sender.state == .Began {
            perGestureTransform = userImageView.transform
        }
        if sender.state == .Began || sender.state == .Changed {
            let scaledTransform = CGAffineTransformScale(perGestureTransform!, sender.scale, sender.scale)
            userImageView.transform = scaledTransform
        }
    }
    
}
