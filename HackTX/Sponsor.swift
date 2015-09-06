//
//  Sponsor.swift
//  HackTX
//
//  Created by Drew Romanyk on 8/23/15.
//  Copyright (c) 2015 HackTX. All rights reserved.
//

import Foundation

class Sponsor: NSObject {
    var name = ""
    var logoImage = ""
    var website = ""
    var level = 0
    
    init(name: String, logoImage: String, website: String, level: Int) {
        self.name = name
        self.logoImage = logoImage
        self.website = website
        self.level = level
    }
}