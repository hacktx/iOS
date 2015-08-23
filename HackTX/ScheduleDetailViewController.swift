//
//  ScheduleDetailViewController.swift
//  HackTX
//
//  Created by Andrew Romanyk on 8/23/15.
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
            
            eventLocation.text = scheduleEvent.location
            eventTime.text = "\(scheduleEvent.startDate!) - \(scheduleEvent.endDate!)"
            eventDesc.text = scheduleEvent.description
            
            
        default:
            cell = UITableViewCell()
        }

        return cell
    }

}
