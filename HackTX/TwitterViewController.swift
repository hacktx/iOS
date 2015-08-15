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
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let topLayoutGuide = CGFloat(60)
//        tableView.contentInset = UIEdgeInsetsMake(topLayoutGuide, 0, 0, 0)
        
        Twitter.sharedInstance().logInGuestWithCompletion { session, error in
            if let validSession = session {
                let client = Twitter.sharedInstance().APIClient
                self.dataSource = TWTRUserTimelineDataSource(screenName: "hacktx", APIClient: client)
            } else {
                println("error: \(error.localizedDescription)")
            }
        }
    }
	
}