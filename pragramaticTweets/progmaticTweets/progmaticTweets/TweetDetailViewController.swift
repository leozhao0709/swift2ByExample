//
//  TweetDetailViewController.swift
//  progmaticTweets
//
//  Created by Lei Zhao on 6/2/16.
//  Copyright © 2016 Lei Zhao. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var userRealNameLabel: UILabel!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    
    
    var tweetIdString: String? {
        didSet {
            reloadTweetDetails()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
////        reloadTweetDetails()
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func reloadTweetDetails() {
        guard let tweetIdString = tweetIdString else {
            return
        }
        if let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/show.json") {
            let twitterParams = ["id": tweetIdString]
            sendTwitterRequest(twitterAPIURL, params: twitterParams, completion: { (data, urlResponse, error) in
                dispatch_async(dispatch_get_main_queue(), { 
                    self.handleTwitterData(data, urlResponse: urlResponse, error: error)
                })
            })
        }
    }
    
    func handleTwitterData (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) {
        guard let data = data else{
            NSLog("handleTwitterData() received no data")
            return
        }
        NSLog("handleTwitterData(), \(data.length) bytes")
        do {
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions([]))
            guard let tweetDict = jsonObject as? [String: AnyObject] else {
                NSLog("handleTwitterData() didn't get a dictionary")
                return
            }
//            print("tweetDict: \(tweetDict)")
            self.tweetTextLabel.text = tweetDict["text"] as? String
            if let userDict = tweetDict["user"] as? [String: AnyObject] {
                self.userRealNameLabel.text = (userDict["name"] as! String)
                self.userScreenNameLabel.text = (userDict["screen_name"] as! String)
                self.userImageButton.setTitle(nil, forState: .Normal)
                if let userImageURL = NSURL(string: userDict["profile_image_url_https"] as! String), userImageData = NSData(contentsOfURL: userImageURL) {
                    self.userImageButton.setImage(UIImage(data: userImageData), forState: .Normal)
                }
                if let entities = tweetDict["entities"] as? [String: AnyObject],
                media = entities["media"] as? [[String: AnyObject]],
                mediaString = media[0]["media_url_https"] as? String,
                mediaURL = NSURL(string: mediaString),
                    mediaData = NSData(contentsOfURL: mediaURL) {
                    tweetImageView.image = UIImage(data: mediaData)
                }
            }
        } catch let error as NSError {
            NSLog("JSON error: \(error)")
        }
    }

}
