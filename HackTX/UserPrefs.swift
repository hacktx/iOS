//
//  UserPref.swift
//  HackTX
//
//  Created by Andrew Romanyk on 9/4/15.
//  Copyright (c) 2015 HackTX. All rights reserved.
//

import Foundation

import Foundation
import UIKit

class UserPrefs {
    
    static var instance: UserPrefs!
    
    class func shared() -> UserPrefs {
        self.instance = (self.instance ?? UserPrefs())
        return self.instance
    }
    
    func getUserDefaults() -> NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    func registerDefaults() {
        let dictionary = ["checkedIn": false,
            "checkInEmail": ""]
        getUserDefaults().registerDefaults(dictionary)
    }
    
    func isCheckedIn() -> Bool {
        return getUserDefaults().boolForKey("checkedIn")
    }
    
    func setIsCheckedIn(checkedIn: Bool) {
        getUserDefaults().setBool(checkedIn, forKey: "checkedIn")
    }
    
    func getCheckedEmail() -> String {
        return getUserDefaults().valueForKey("checkInEmail") as! String
    }
    
    func setCheckedEmail(checkedEmail: String) {
        getUserDefaults().setValue(checkedEmail, forKey: "checkInEmail")
    }
}