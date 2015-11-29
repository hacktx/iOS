//
//  TwitterViewController.swift
//  HackTX
//
//  Created by Rohit Datta on 7/11/15.
//  Copyright (c) 2015 HackTX. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit

class TwitterViewController: TWTRTimelineViewController {
	
//	let reachability = Reachability.reachabilityForInternetConnection()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let topLayoutGuide = CGFloat(60)
//        tableView.contentInset = UIEdgeInsetsMake(topLayoutGuide, 0, 0, 0)
		if !Reachability.isConnectedToNetwork() {
			print("Internet connection FAILED")
			let alert = UIAlertView(title: "No Internet Connection", message: "The HackTX app requires an internet connection to work. Talk to a volunteer about getting Internet access.", delegate: nil, cancelButtonTitle: "OK")
			alert.show()
		}
        Twitter.sharedInstance().logInGuestWithCompletion { session, error in
            if let _ = session {
                let client = Twitter.sharedInstance().APIClient
                self.dataSource = TWTRUserTimelineDataSource(screenName: "hacktx", APIClient: client)
            } else {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    // Setup Google Analytics for the controller
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Twitter")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
	
}