//
//  WebViewTests.swift
//  progmaticTweets
//
//  Created by Lei Zhao on 5/28/16.
//  Copyright © 2016 Lei Zhao. All rights reserved.
//

//import XCTest
//@testable import progmaticTweets
//
//class WebViewTests: XCTestCase, UIWebViewDelegate {
//    
//    var loadedWebViewException: XCTestExpectation?
//    
//    override func setUp() {
//        super.setUp()
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//    
//    func testAutomaticWebLoad() {
//        guard let ViewController = UIApplication.sharedApplication().windows[0].rootViewController as? ViewController else {
//            XCTFail("couldn't get root view controller")
//            return
//        }
//        
//        ViewController.twitterWebView.delegate = self
//        loadedWebViewException = expectationWithDescription("web view auto-load test")
//        waitForExpectationsWithTimeout(5.0, handler: nil)
//    }
//    
//    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
//        XCTFail("web view load failed")
//        loadedWebViewException?.fulfill()
//    }
//    
//    func webViewDidFinishLoad(webView: UIWebView) {
//        if let webViewContents = webView.stringByEvaluatingJavaScriptFromString("document.documentElement.textContent") where webViewContents != "" {
//            loadedWebViewException?.fulfill()
//        }
//    }
//
//    
//}
