//
//  TwitterAPIRequestUtilities.swift
//  progmaticTweets
//
//  Created by Lei Zhao on 6/1/16.
//  Copyright © 2016 Lei Zhao. All rights reserved.
//

import Social
import Accounts

func sendTwitterRequest (requestURL: NSURL, params: [String: String], completion: SLRequestHandler)
{
    let accountStore = ACAccountStore()
    let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    accountStore.requestAccessToAccountsWithType(twitterAccountType, options: nil) { (granted: Bool, error: NSError!) in
        guard granted else {
            NSLog("account access not granted")
            return
        }
        let twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
        guard twitterAccounts.count > 0 else {
            NSLog("no twitter accounts configured")
            return
        }
        
        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: requestURL, parameters: params)
        
        request.account = twitterAccounts.first as! ACAccount
        request.performRequestWithHandler(completion)
    }
}