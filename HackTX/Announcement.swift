//
//  Announcement.swift
//  HackTX
//
//  Created by Andrew Romanyk on 8/15/15.
//  Copyright (c) 2015 HackTX. All rights reserved.
//

import Foundation

class Announcement: NSObject {
    var text = ""
    var ts = ""
    
    init(text: String, ts: String) {
        self.text = text
        self.ts = ts
    }
}
