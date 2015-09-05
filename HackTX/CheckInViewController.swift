//
//  CheckInViewController.swift
//  HackTX
//
//  Created by Andrew Romanyk on 9/4/15.
//  Copyright (c) 2015 HackTX. All rights reserved.
//

import UIKit
import AVFoundation

class CheckInViewController: UITableViewController {
    
    var emailField : UITextField? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 215
        tableView.rowHeight = UITableViewAutomaticDimension

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // Setup Google Analytics for the controller
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "CheckIn")
        
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
        var cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as! UITableViewCell

        switch (indexPath.row) {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as! UITableViewCell
            let desc = cell.viewWithTag(1001) as! UILabel
            desc.preferredMaxLayoutWidth = CGRectGetWidth(desc.frame)
        case 1:
            if(!UserPrefs.shared().isCheckedIn()){
                cell = tableView.dequeueReusableCellWithIdentifier("AboutCell", forIndexPath: indexPath) as! UITableViewCell
                emailField = cell.viewWithTag(1000) as! UITextField
                let enterButton = cell.viewWithTag(1001) as! UIButton
                enterButton.addTarget(self, action: "enterEmailToQr:", forControlEvents: UIControlEvents.TouchUpInside)
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier("CheckInCell", forIndexPath: indexPath) as! UITableViewCell
                
                // Setup email text
                let desc = cell.viewWithTag(1000) as! UILabel
                let emailLabel = cell.viewWithTag(1001) as! UILabel
                emailLabel.text = "Your email is \(UserPrefs.shared().getCheckedEmail())"
                desc.preferredMaxLayoutWidth = CGRectGetWidth(desc.frame)
                emailLabel.preferredMaxLayoutWidth = CGRectGetWidth(emailLabel.frame)
                
                // Setup QR Image
                let qrImageView = cell.viewWithTag(1002) as! UIImageView
                let qrr = RSUnifiedCodeGenerator().generateCode(UserPrefs.shared().getCheckedEmail(), machineReadableCodeObjectType: AVMetadataObjectTypeQRCode)
                let qrScale = RSAbstractCodeGenerator.resizeImage(qrr!, scale: 10)
                qrImageView.image = qrScale
                
                // Setup reset button
                let resetButton = cell.viewWithTag(1003) as! UIButton
                resetButton.addTarget(self, action: "resetQrAccount:", forControlEvents: UIControlEvents.TouchUpInside)
            }
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as! UITableViewCell
        }

        return cell
    }
    
    func enterEmailToQr(sender: UIButton!) {
        if (emailField != nil) {
            let emailStr = emailField?.text
            if (emailStr!.length() != 0 && emailStr!.contains("@")) {
                UserPrefs.shared().setIsCheckedIn(true)
                UserPrefs.shared().setCheckedEmail(emailStr!)
                tableView.reloadData()
            }
        }
    }
    
    func resetQrAccount(sender: UIButton!) {
        UserPrefs.shared().setIsCheckedIn(false)
        UserPrefs.shared().setCheckedEmail("")
        tableView.reloadData()
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
