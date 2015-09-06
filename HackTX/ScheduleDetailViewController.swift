//
//  ScheduleDetailViewController.swift
//  HackTX
//
//  Created by Drew Romanyk on 8/23/15.
//  Copyright (c) 2015 HackTX. All rights reserved.
//

import UIKit

class ScheduleDetailViewController: UITableViewController {
    
    var scheduleEvent = Event()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 215
        tableView.rowHeight = UITableViewAutomaticDimension
        
        title = scheduleEvent.name
		
    }
    
    // Setup Google Analytics for the controller
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "ScheduleDetails-\(scheduleEvent.id)")
        
        var builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 2
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! UITableViewCell
            
            let imageUI = cell.viewWithTag(1000) as! UIImageView
            
            let image_link_url = NSURL(string: scheduleEvent.imageUrl!)
            // The image isn't cached, download the img data
            // We should perform this in a background thread
            let request: NSURLRequest = NSURLRequest(URL: image_link_url!)
            let mainQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    // Convert the downloaded data in to a UIImage object
                    let image = UIImage(data: data)
                    // Store the image in to our cache
                    let loadedImage = image
                    // Update the cell
                    dispatch_async(dispatch_get_main_queue(), {
                        imageUI.image = loadedImage
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath) as! UITableViewCell
            
            let eventLocation = cell.viewWithTag(1000) as! UILabel
            let eventTime = cell.viewWithTag(1001) as! UILabel
            let eventDesc = cell.viewWithTag(1002) as! UILabel
			let speakerTagName = cell.viewWithTag(999) as! UILabel
			
			let eventSpeaker = scheduleEvent.speakerList!.first
			if eventSpeaker == nil {
				speakerTagName.text = ""
			}
            
            if let speakerNameCell = cell.viewWithTag(1005) as? UILabel {
                let speakerDescriptionCell = cell.viewWithTag(1007) as! UILabel
                let speakerImageCell = cell.viewWithTag(1008) as! UIImageView
                speakerNameCell.text = eventSpeaker?.name
                speakerDescriptionCell.text = eventSpeaker?.description
                if eventSpeaker != nil {
                    
                    let image_link_url = NSURL(string: eventSpeaker!.imageUrl)
                    // The image isn't cached, download the img data
                    // We should perform this in a background thread
                    let request: NSURLRequest = NSURLRequest(URL: image_link_url!)
                    let mainQueue = NSOperationQueue.mainQueue()
                    NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                        if error == nil {
                            // Convert the downloaded data in to a UIImage object
                            let image = UIImage(data: data)
                            // Store the image in to our cache
                            let loadedImage = image
                            // Update the cell
                            dispatch_async(dispatch_get_main_queue(), {
                                speakerImageCell.image = loadedImage
                            })
                        }
                        else {
                            println("Error: \(error.localizedDescription)")
                        }
                    })
                    
                    speakerImageCell.layer.cornerRadius = speakerImageCell.frame.size.width / 2
                    speakerImageCell.clipsToBounds = true
                }
            }
			
			
			let dateFormatter = NSDateFormatter()
			dateFormatter.dateFormat = "h:mm a"
			let startTime = dateFormatter.stringFromDate(scheduleEvent.startDate!)
			let endTime = dateFormatter.stringFromDate(scheduleEvent.endDate!)
			
            eventLocation.text = scheduleEvent.location!.description()
            eventTime.text = "\(startTime) - \(endTime)"
            eventDesc.text = scheduleEvent.description
			
        default:
            cell = UITableViewCell()
        }

        return cell
    }

}
