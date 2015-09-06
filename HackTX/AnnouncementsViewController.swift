//
//  AnnouncementsViewController.swift
//  HackTX
//
//  Created by Drew Romanyk on 8/15/15.
//  Copyright (c) 2015 HackTX. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AnnouncementsViewController: UITableViewController {
    
    var announcementList = [Announcement]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        getAnnouncementData()
    }
    
    
    
    // Collect announcement data from the api
    func getAnnouncementData() {
        Alamofire.request(Router.Announcements())
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
                    self.announcementList.removeAll(keepCapacity: true)
                    
                    for (index: String, subJson: JSON) in json {
                        self.announcementList.append(Announcement(text: subJson["text"].stringValue, ts: subJson["ts"].stringValue))
                    }
                    self.announcementList.sort(self.sortAnnouncements)
                    self.tableView.reloadData()
                }
        }
    }
    
    // Sort announcement messages by newest to oldest
    func sortAnnouncements(this: Announcement, that: Announcement) -> Bool {
        return this.getTsDate().compare(that.getTsDate()) == NSComparisonResult.OrderedDescending
    }
    
    // Setup Google Analytics for the controller
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Announcements")
        
        var builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
     * TABLE VIEW METHODS
     */
    
    // Refresh the tableview data
    @IBAction func refresh(sender: UIRefreshControl) {
        getAnnouncementData()
        sender.endRefreshing()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcementList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AnnouncementCell", forIndexPath: indexPath) as! UITableViewCell
        let announcement = announcementList[indexPath.row]

        cell.textLabel!.text = announcement.text
        cell.detailTextLabel!.text = announcement.getEnglishTs()
		cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
}
