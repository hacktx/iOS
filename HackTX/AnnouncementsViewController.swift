//
//  AnnouncementsViewController.swift
//  HackTX
//
//  Created by Andrew Romanyk on 8/15/15.
//  Copyright (c) 2015 HackTX. All rights reserved.
//

import UIKit

class AnnouncementsViewController: UITableViewController {
    
    var announcementList = [Announcement]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let errorAlert = UIAlertView()
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension

        let endpoint = "http://hacktx.getsandbox.com/announcements"
        request(.GET, endpoint)
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
                    self.announcementList.removeAll(keepCapacity: true)
                    
                    for (index: String, subJson: JSON) in json {
                        self.announcementList.append(Announcement(text: subJson["text"].stringValue, ts: subJson["ts"].stringValue))
                    }
                    
                    self.tableView.reloadData()
                }
        }
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
        return announcementList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AnnouncementCell", forIndexPath: indexPath) as! UITableViewCell
        let announcement = announcementList[indexPath.row]

        cell.textLabel!.text = announcement.text
        cell.detailTextLabel!.text = announcement.ts

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
