//
//  ViewController.swift
//  progmaticTweets
//
//  Created by Lei Zhao on 5/27/16.
//  Copyright © 2016 Lei Zhao. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController {
    
    
    @IBOutlet weak var twitterWebView: UIWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleTweetButtonTapped(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let tweetVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetVC.setInitialText("I just finished the first project in IOS 9 SDK Development. #prasios9")
            self.presentViewController(tweetVC, animated: true, completion: nil)
        }
        else {
            NSLog("Can't send tweet")
        }
    }

    @IBAction func handleShowMyTweetsTapped(sender: UIButton) {
//        if let url = NSURL(string: "https://twitter.com/pragsiostest") {
//            let urlRequest = NSURLRequest(URL: url)
//            self.twitterWebView.loadRequest(urlRequest)
//        }
        guard let url = NSURL(string: "https://twitter.com/LeiZhao3") else {
            return
        }
        let urlRequest = NSURLRequest(URL: url)
        self.twitterWebView.loadRequest(urlRequest)
    }
    
}

