//
//  CheckInViewController.swift
//  HackTX
//
//  Created by Drew Romanyk on 9/4/15.
//  Copyright (c) 2015 HackTX. All rights reserved.
//

import UIKit
import AVFoundation
import RSBarcodes_Swift

class CheckInViewController: UITableViewController {
    
    var emailField : UITextField? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 215
        tableView.rowHeight = UITableViewAutomaticDimension
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
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
                emailField = cell.viewWithTag(1000) as? UITextField
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
                // RSAbstractCodeGenerator.generateCode(contents, filterName: RSAbstractCodeGenerator.filterName(machineReadableCodeObjectType))
                //let qrr = RSUnifiedCodeGenerator().generateCode(UserPrefs.shared().getCheckedEmail(), machineReadableCodeObjectType: AVMetadataObjectTypeQRCode)
                let qrr = RSAbstractCodeGenerator.generateCode(UserPrefs.shared().getCheckedEmail(), filterName: RSAbstractCodeGenerator.filterName(AVMetadataObjectTypeQRCode))
                let qrScale = RSAbstractCodeGenerator.resizeImage(qrr, scale: 10)
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
            if (count(emailStr!) != 0 && emailStr!.rangeOfString("@") != nil) {
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

}
