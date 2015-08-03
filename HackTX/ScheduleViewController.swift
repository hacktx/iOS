//
//  FirstViewController.swift
//  HackTX
//
//  Created by Gilad Oved on 7/11/15.
//  Copyright (c) 2015 HackTX. All rights reserved.
//

import UIKit
import Alamofire

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chooseDaySegmentControl: UISegmentedControl!
    
    let numberOfDays = 2
    var days = [Day]()
    
	override func viewDidLoad() {
		super.viewDidLoad()
        let errorAlert = UIAlertView()
        
        days = [Day]()
        for i in 0..<numberOfDays {
            Alamofire.request(.GET, "http://hacktx.getsandbox.com/schedule/\(i+1)")
                .responseJSON { _, _, jsonData, _ in
                    if let jsonData:AnyObject = jsonData {
                        let json = JSON(jsonData)
                        var day = Day()
                        day.name = json[0]["name"].stringValue
                        day.id = json[0]["id"].intValue
                        var events = [Event]()
                        for (key: String, subJson: JSON) in json[0]["eventsList"] {
                            var event: Event = Event()
                            event.location = subJson["location"].stringValue
                            event.endDateStr = subJson["endDate"].stringValue
                            event.id = subJson["id"].intValue
                            event.startDateStr = subJson["startData"].stringValue
                            event.imageUrl = subJson["imageUrl"].stringValue
                            event.type = subJson["type"].stringValue
                            event.description = subJson["description"].stringValue
                            event.name = subJson["name"].stringValue
                            var speakers = [Speaker]()
                            for (speakerKey: String, speakerJson: JSON) in subJson["speakerList"] {
                                var speaker:Speaker = Speaker()
                                speaker.id = speakerJson["id"].intValue
                                speaker.organization = speakerJson["organization"].stringValue
                                speaker.imageUrl = speakerJson["imageUrl"].stringValue
                                speaker.name = speakerJson["name"].stringValue
                                speaker.description = speakerJson["description"].stringValue
                                speakers.append(speaker)
                            }
                            event.speakerList = speakers
                            events.append(event)
                        }
                        day.eventsList = events
                        self.days.append(day)
                        
                        self.tableView.reloadData()
                    } else {
                        if errorAlert.title == "" {
                            errorAlert.title = "Error"
                            errorAlert.message = "Oops! Looks like there was a problem trying to get the schedule"
                            errorAlert.addButtonWithTitle("Ok")
                            errorAlert.show()
                        }
                    }
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if days.count != 0 {
            if let events = days[chooseDaySegmentControl.selectedSegmentIndex].eventsList {
                return events.count
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "ScheduleCell")
        
        if let events = days[chooseDaySegmentControl.selectedSegmentIndex].eventsList {
            cell.textLabel?.text = events[indexPath.row].name
            cell.detailTextLabel?.text = events[indexPath.row].description
        }
        
        return cell
    }

    @IBAction func choseDifferentDay(sender: AnyObject) {
        tableView.reloadData()
    }

}


class Day {
    var id : Int? = 0
    var name: String? = ""
    var eventsList: [Event]?
}

class Event {
    var id : Int? = 0
    var name: String? = ""
    var type: String? = ""
    var imageUrl: String? = ""
    var startDate: NSDate? = NSDate()
    var endDate: NSDate? = NSDate()
    var startDateStr: String? = ""
    var endDateStr: String? = ""
    var location: String? = ""
    var description: String? = ""
    var speakerList: [Speaker]?
}

class Speaker {
    var id: Int? = 0
    var name: String = ""
    var organization: String = ""
    var description: String = ""
    var imageUrl: String = ""
}

