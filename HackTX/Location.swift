//
//  Location.swift
//  HackTX
//
//  Created by Rohit Datta on 9/2/15.
//  Copyright (c) 2015 HackTX. All rights reserved.
//

import Foundation

class Location {
	var building: String? = ""
	var level: String? = ""
	var room: String? = ""
	
	init(building: String, level: String, room: String) {
		self.building = building
		self.level = level
		self.room = room
	}
	
	func description() -> String{
		return building! + " Level " + level! + " - " + room!
	}
	
}