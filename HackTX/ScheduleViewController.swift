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
		if Reachability.isConnectedToNetwork() {
			print("Internet connection OK")
			getScheduleData()
		} else {
			print("Internet connection FAILED")
			let alert = UIAlertView(title: "No Internet Connection", message: "The HackTX app requires an internet connection to work. Talk to a volunteer about getting Internet access.", delegate: nil, cancelButtonTitle: "OK")
			alert.show()
		}
		
    }
    
	func refresh(sender: AnyObject) {
		if Reachability.isConnectedToNetwork() {
			print("Internet connection OK")
			getScheduleData()
		} else {
			print("Internet connection FAILED")
			let alert = UIAlertView(title: "No Internet Connection", message: "The HackTX app requires an internet connection to work. Talk to a volunteer about getting Internet access.", delegate: nil, cancelButtonTitle: "OK")
			alert.show()
		}
		self.refreshControl.endRefreshing()
    }
    
    func getScheduleData() {
        for i in 0..<numberOfDays {
			
			
			Alamofire.request(Router.Schedule(String(i + 1)))
				.responseJSON{ (request, response, data) in
					if data.isFailure {
						let errorAlert = UIAlertView()
						if errorAlert.title == "" {
							errorAlert.title = "Error"
							errorAlert.message = "Oops! Looks like there was a problem trying to get the announcements"
							errorAlert.addButtonWithTitle("Ok")
							errorAlert.show()
						}

					} else if let data: AnyObject = data.value {
						let json = JSON(data)
						var curDay = Day()
						var clusterList = [ScheduleCluster]()
						
						
						
						for (index: String, subJson: JSON) in json {
							var curCluster = ScheduleCluster()
							curCluster.id = JSON["id"].intValue
							curCluster.name = JSON["name"].stringValue
							var eventList = [Event]()
							
							for (key: String, subJson: JSON) in JSON["eventsList"] {
								var event: Event = Event()
								event.location = Location(building: JSON["location"]["building"].stringValue, level: JSON["location"]["level"].stringValue, room: JSON["location"]["room"].stringValue)
								
								event.id = JSON["id"].intValue
								event.startDateStr = JSON["startDate"].stringValue
								event.endDateStr = JSON["endDate"].stringValue
								event.convertDateStrToDates()
								event.imageUrl = JSON["imageUrl"].stringValue
								event.type = JSON["type"].stringValue
								event.description = JSON["description"].stringValue
								event.name = JSON["name"].stringValue
								
								var speakers = [Speaker]()
								for (speakerKey: String, speakerJson: JSONspeaker) in JSON["speakerList"] {
									var speaker:Speaker = Speaker()
									speaker.id = JSONspeaker["id"].intValue
									speaker.organization = JSONspeaker["organization"].stringValue
									speaker.imageUrl = JSONspeaker["imageUrl"].stringValue
									speaker.name = JSONspeaker["name"].stringValue
									speaker.description = JSONspeaker["description"].stringValue
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
		tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: false)
    }

    @IBAction func choseDifferentDay(sender: AnyObject) {
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowEvent" {
            let controller = segue.destinationViewController as! ScheduleDetailViewController
            controller.scheduleEvent = sender as! Event
        }
    }

}

