//
//  ViewController.swift
//  pragmaticTweets
//
//  Created by Lei Zhao on 5/27/16.
//  Copyright © 2016 Lei Zhao. All rights reserved.
//

import UIKit
import Social
import Accounts
import Photos

let defaultAvatarURL = NSURL(string: "https://abs.twimg.com/sticky/default_profile_images/default_profile_6_200x200.png")

class RootViewController: UITableViewController, UISplitViewControllerDelegate {
    
    
    var parsedTweets: [ParsedTweet] = []
    
    @IBAction func handleTweetButtonTapped(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
           let tweetVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetVC.setInitialText("I just finished the first project in IOS 9 SDK Development. #pragsios9")
            self.presentViewController(tweetVC, animated: true, completion: nil)
        } else {
            NSLog("Can't send tweet")
        }
    }
    
    @IBAction func handlePhotoButtonTapped(sender: UIBarButtonItem) {
        let fetchOptions = PHFetchOptions()
        PHPhotoLibrary.requestAuthorization { (authorized: PHAuthorizationStatus) in
            if authorized == .Authorized {
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                let fetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: fetchOptions)
                if let firstPhoto = fetchResult.firstObject as? PHAsset {
                    self.createTweetForAsset(firstPhoto)
                }
            }
        }
    }
    
    func createTweetForAsset(asset: PHAsset) {
        let requestOptions = PHImageRequestOptions()
        requestOptions.synchronous = true
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSize(width: 640.0, height: 480), contentMode: .AspectFit, options: requestOptions) { (image: UIImage?, info: [NSObject : AnyObject]?) in
            if let image = image where SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                let tweetVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                tweetVC.setInitialText("Here's a photo I tweeted. #pragsios9")
                tweetVC.addImage(image)
                dispatch_async(dispatch_get_main_queue(), { 
                    self.presentViewController(tweetVC, animated: true, completion: nil)
                })
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.reloadTweets()
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(RootViewController.handleRefresh(_:)), forControlEvents: .ValueChanged)
        refreshControl = refresher
        
        if let splitViewController = self.splitViewController {
            splitViewController.delegate = self
            NSLog("split exist ***")
            addShowSplitPrimaryButton(splitViewController)
        }
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    func splitViewController(svc: UISplitViewController, willChangeToDisplayMode displayMode: UISplitViewControllerDisplayMode) {
        if displayMode == .PrimaryHidden {
            self.addShowSplitPrimaryButton(svc)
        }
    }
    
    func addShowSplitPrimaryButton(splitViewController: UISplitViewController) {
        let barbuttonItem = splitViewController.displayModeButtonItem()
        if let detailNav = splitViewController.viewControllers.last as? UINavigationController {
            detailNav.topViewController?.navigationItem.leftBarButtonItem = barbuttonItem
            NSLog("add detail bar button item")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedTweets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomTweetCell") as! ParsedTweetCell
        let parsedTweet = parsedTweets[indexPath.row]
        cell.userNameLabel.text = parsedTweet.userName
        cell.tweetTextLabel.text = parsedTweet.tweetText
        cell.createdAtLabel.text = parsedTweet.createdAt
        cell.avatarImageView.image = nil
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) { 
            if let url = parsedTweet.userAvatarURL, imageData = NSData(contentsOfURL: url) where cell.userNameLabel.text == parsedTweet.userName {
                dispatch_async(dispatch_get_main_queue(), { 
                    cell.avatarImageView.image = UIImage(data: imageData)
                })
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let parsedTweet = parsedTweets[indexPath.row]
        if let splitViewController = self.splitViewController where splitViewController.viewControllers.count > 1 {
            if let tweetDetailNav = splitViewController.viewControllers[1] as? UINavigationController, tweetDetailVC = tweetDetailNav.viewControllers[0] as? TweetDetailViewController {
                tweetDetailVC.tweetIdString = parsedTweet.tweetIdString
            }
        }
        else {
            if let storyboard = self.storyboard,
                detailVC = storyboard.instantiateViewControllerWithIdentifier("TweetDetailVC") as? TweetDetailViewController {
                detailVC.tweetIdString = parsedTweet.tweetIdString
                splitViewController?.showDetailViewController(detailVC, sender: self)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func reloadTweets() {        
        let twitterParams = ["count": "100"]
        guard let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json") else {
            return
        }
        sendTwitterRequest(twitterAPIURL, params: twitterParams) { (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) in
            self.handleTwitterData(data, urlResponse: urlResponse, error: error)
        }
    }
    
    @IBAction func handleRefresh(sender: AnyObject?) {
        self.reloadTweets()
        refreshControl?.endRefreshing()
    }
    
    private func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) {
        guard let data = data else {
            NSLog("handleTwitterData() received no data")
            return
        }
        NSLog("handleTwitterData(), \(data.length) bytes")
        do {
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions([]))
            guard let jsonArray = jsonObject as? [[String: AnyObject]] else {
                NSLog("handleTwitterData() didn't get an array")
                return
            }
            parsedTweets.removeAll()
            for tweetDict in jsonArray {
                var parsedTweet = ParsedTweet()
                parsedTweet.tweetText = tweetDict["text"] as? String
                parsedTweet.createdAt = tweetDict["created_at"] as? String
                parsedTweet.tweetIdString = tweetDict["id_str"] as? String
                if let userDict = tweetDict["user"] as? [String: AnyObject] {
                    parsedTweet.userName = userDict["name"] as? String
                    if let avatarURLString = userDict["profile_image_url_https"] as? String {
                        parsedTweet.userAvatarURL = NSURL(string: avatarURLString)
                    }
                }
                parsedTweets.append(parsedTweet)
            }
            NSLog(NSThread.isMainThread() ? "on main thread": "Not main thread")
            dispatch_async(dispatch_get_main_queue(), {
                NSLog(NSThread.isMainThread() ? "on main thread": "Not main thread")
                self.tableView.reloadData()
            })
            
        } catch let error as NSError {
            NSLog("JSON error: \(error)")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTweetDetailsSegue" {
            if let row = self.tableView.indexPathForSelectedRow?.row,
            tweetDetailsVC = segue.destinationViewController as? TweetDetailViewController{
                let parsedTweet = parsedTweets[row]
                tweetDetailsVC.tweetIdString = parsedTweet.tweetIdString
            }
        }
    }
    
    

}

