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
import Fabric

class TwitterViewController: TWTRTimelineViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Twitter.sharedInstance().logInGuestWithCompletion { session, error in
            if let validSession = session {
                let client = Twitter.sharedInstance().APIClient
                self.dataSource = TWTRUserTimelineDataSource(screenName: "HackTX", APIClient: client)
            } else {
                let alert = UIAlertView()
                alert.title = "Error!"
                alert.message = "Uh Oh! There's an error trying to view the tweets. Sorry about that..."
                alert.addButtonWithTitle("Ok")
                alert.show()
                println("error: \(error.localizedDescription)")
            }
        }
    }
    
}