//
//  FirstViewController.swift
//  HackTX
//
//  Created by Gilad Oved on 7/11/15.
//  Copyright (c) 2015 HackTX. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chooseDaySegmentControl: UISegmentedControl!
	
    let numberOfDays = 2
    var dayDict = [Int:Day]()
	var refreshControl: UIRefreshControl!
    
	override func viewDidLoad() {
		super.viewDidLoad()
		self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor(red: 125/255.0, green: 211/255.0, blue: 244/255.0, alpha: 1.0)
		self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
		self.tableView.addSubview(refreshControl)
		if Reachability.isConnectedToNetwork() == true {
			println("Internet connection OK")
			getScheduleData()
		} else {
			println("Internet connection FAILED")
			var alert = UIAlertView(title: "No Internet Connection", message: "The HackTX app requires an internet connection to work. Talk to a volunteer about getting Internet access.", delegate: nil, cancelButtonTitle: "OK")
			alert.show()
		}
		
    }
    
	func refresh(sender: AnyObject) {
		if Reachability.isConnectedToNetwork() == true {
			println("Internet connection OK")
			getScheduleData()
		} else {
			println("Internet connection FAILED")
			var alert = UIAlertView(title: "No Internet Connection", message: "The HackTX app requires an internet connection to work. Talk to a volunteer about getting Internet access.", delegate: nil, cancelButtonTitle: "OK")
			alert.show()
		}
		self.refreshControl.endRefreshing()
    }
    
    func getScheduleData() {
        for i in 0..<numberOfDays {
            
            Alamofire.request(Router.Schedule(String(i + 1)))
                .responseJSON { (request, response, data, error) in
                    if let anError = error {
                        let errorAlert = UIAlertView()
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
                                event.location = Location(building: subJson["location"]["building"].stringValue, level: subJson["location"]["level"].stringValue, room: subJson["location"]["room"].stringValue)
                                
                                event.id = subJson["id"].intValue
                                event.startDateStr = subJson["startDate"].stringValue
                                event.endDateStr = subJson["endDate"].stringValue
                                event.convertDateStrToDates()
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
                        //self.dayList.append(curDay)
                        self.dayDict.updateValue(curDay, forKey: i)
                        self.tableView.reloadData()
                    }
            }
        }
    }
    
    func sorterForDays(this: Day, that: Day) -> Bool {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date1 = dateFormatter.dateFromString(this.clusterList[0].eventsList![0].startDateStr!)
        let date2 = dateFormatter.dateFromString(that.clusterList[0].eventsList![0].startDateStr!)
        
        return date1!.compare(date2!) == NSComparisonResult.OrderedAscending
    }
    
    // Setup Google Analytics for the controller
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Schedule")
        
        var builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if(dayDict.indexForKey(chooseDaySegmentControl.selectedSegmentIndex) == nil) {
            return 0
        }
        
        return dayDict[chooseDaySegmentControl.selectedSegmentIndex]!.clusterList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let scheduleCluster = dayDict[chooseDaySegmentControl.selectedSegmentIndex]!.clusterList[section]
        
        return scheduleCluster.eventsList!.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let scheduleCluster = dayDict[chooseDaySegmentControl.selectedSegmentIndex]!.clusterList[section]
        
        return scheduleCluster.name
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "ScheduleCell")
        let scheduleCluster = dayDict[chooseDaySegmentControl.selectedSegmentIndex]!.clusterList[indexPath.section] as ScheduleCluster
        let event = scheduleCluster.eventsList![indexPath.row] as Event
        
        cell.textLabel!.text = event.name
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "h:mm a"
		let startTime = dateFormatter.stringFromDate(event.startDate!)
		let endTime = dateFormatter.stringFromDate(event.endDate!)
		
        cell.detailTextLabel!.text = "\(startTime) - \(endTime) | \(event.location!.description())"
		switch event.type! {
		case "talk":
			cell.imageView?.image = UIImage(named: "event_talk")
		case "education":
			cell.imageView?.image = UIImage(named: "event_school")
		case "bus":
			cell.imageView?.image = UIImage(named: "event_bus")
		case "food":
			cell.imageView?.image = UIImage(named: "event_food")
		case "dev":
			cell.imageView?.image = UIImage(named: "event_dev")
		default:
			cell.imageView?.image = UIImage(named: "event_default")
		}
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let scheduleCluster = dayDict[chooseDaySegmentControl.selectedSegmentIndex]!.clusterList[indexPath.section]
        let event = scheduleCluster.eventsList![indexPath.row]
        performSegueWithIdentifier("ShowEvent", sender: event)
		tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow()!, animated: false)
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

