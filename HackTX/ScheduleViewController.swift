//
//  FirstViewController.swift
//  HackTX
//
//  Created by Gilad Oved on 7/11/15.
//  Copyright (c) 2015 HackTX. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chooseDaySegmentControl: UISegmentedControl!
    
    let numberOfDays = 2
    var dayList = [Day]()
    
	override func viewDidLoad() {
		super.viewDidLoad()
        let errorAlert = UIAlertView()
        
        dayList.removeAll(keepCapacity: true)
        
        for i in 0..<numberOfDays {
            
            request(.GET, "http://hacktx.getsandbox.com/schedule/\(i+1)")
                .responseJSON { (request, response, data, error) in
                    if let anError = error {
                        if errorAlert.title == "" {
                            errorAlert.title = "Error"
                            errorAlert.message = "Oops! Looks like there was a problem trying to get the announcements"
                            errorAlert.addButtonWithTitle("Ok")
                            errorAlert.show()
                        }
                    } else {
                        let json = JSON(data!)
                        var curDay = Day()
                        var clusterList = [ScheduleCluster]()
                        
                        for (index: String, subJson: JSON) in json {
                            var curCluster = ScheduleCluster()
                            curCluster.id = subJson["id"].intValue
                            curCluster.name = subJson["name"].stringValue
                            var eventList = [Event]()
                            
                            for (key: String, subJson: JSON) in subJson["eventsList"] {
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
                                eventList.append(event)
                            }
                            
                            curCluster.eventsList = eventList
                            clusterList.append(curCluster)
                        }
                        
                        curDay.clusterList = clusterList
                        self.dayList.append(curDay)
                        self.dayList.sort({ $0.clusterList[0].id < $1.clusterList[0].id })
                        self.tableView.reloadData()
                    }
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if(dayList.count == 0) {
            return 0
        }
        
        return dayList[chooseDaySegmentControl.selectedSegmentIndex].clusterList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let scheduleCluster = dayList[chooseDaySegmentControl.selectedSegmentIndex].clusterList[section]
        
        return scheduleCluster.eventsList!.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let scheduleCluster = dayList[chooseDaySegmentControl.selectedSegmentIndex].clusterList[section]
        
        return scheduleCluster.name
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "ScheduleCell")
        let scheduleCluster = dayList[chooseDaySegmentControl.selectedSegmentIndex].clusterList[indexPath.section] as ScheduleCluster
        let event = scheduleCluster.eventsList![indexPath.row] as Event
        
        cell.textLabel!.text = event.name
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "hh:mm"
		let startTime = dateFormatter.stringFromDate(event.startDate!)
		let endTime = dateFormatter.stringFromDate(event.endDate!)
		
        cell.detailTextLabel!.text = "\(startTime) - \(endTime) | \(event.location!)"
		switch event.type! {
		case "talk":
			cell.imageView?.image = UIImage(named: "talk.png")
		case "education":
			cell.imageView?.image = UIImage(named: "education.png")
		case "bus":
			cell.imageView?.image = UIImage(named: "bus.png")
		case "food":
			cell.imageView?.image = UIImage(named: "food.png")
		case "dev":
			cell.imageView?.image = UIImage(named: "dev.png")
		default:
			cell.imageView?.image = UIImage(named: "event.png")
		}
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let scheduleCluster = dayList[chooseDaySegmentControl.selectedSegmentIndex].clusterList[indexPath.section]
        let event = scheduleCluster.eventsList![indexPath.row]
        performSegueWithIdentifier("ShowEvent", sender: event)
    }

    @IBAction func choseDifferentDay(sender: AnyObject) {
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowEvent" {
            let navController = segue.destinationViewController as! UINavigationController
            let controller = navController.topViewController as! ScheduleDetailViewController
            controller.scheduleEvent = sender as! Event
        }
    }

}

