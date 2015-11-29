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
        
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    // Setup Google Analytics for the controller
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "CheckIn")
        
        let builder = GAIDictionaryBuilder.createScreenView()
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
        var cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) 

        switch (indexPath.row) {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) 
            let desc = cell.viewWithTag(1001) as! UILabel
            desc.text = ""
            desc.text = "Lets get through the line quick."
            desc.preferredMaxLayoutWidth = CGRectGetWidth(desc.frame)
        case 1:
            if(!UserPrefs.shared().isCheckedIn()){
                cell = tableView.dequeueReusableCellWithIdentifier("AboutCell", forIndexPath: indexPath) 
                emailField = cell.viewWithTag(1000) as? UITextField
				emailField?.keyboardType = UIKeyboardType.EmailAddress
                let enterButton = cell.viewWithTag(1001) as! UIButton
                enterButton.addTarget(self, action: "enterEmailToQr:", forControlEvents: UIControlEvents.TouchUpInside)
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier("CheckInCell", forIndexPath: indexPath) 
                
                // Setup email text
                let desc = cell.viewWithTag(1000) as! UILabel
                let emailLabel = cell.viewWithTag(1001) as! UILabel
				let emailPrefix = "Your email is "
				let email = "\(UserPrefs.shared().getCheckedEmail())"
				
				//bold the email
				let attributedString = NSMutableAttributedString(string:emailPrefix)
				let attrs = [NSFontAttributeName : UIFont.boldSystemFontOfSize(15)]
				let boldString = NSMutableAttributedString(string:email, attributes:attrs)
				attributedString.appendAttributedString(boldString)
				
				
				emailLabel.attributedText = attributedString
                desc.preferredMaxLayoutWidth = CGRectGetWidth(desc.frame)
                emailLabel.preferredMaxLayoutWidth = CGRectGetWidth(emailLabel.frame)
                
                // Setup QR Image
                let qrImageView = cell.viewWithTag(1002) as! UIImageView
                // RSAbstractCodeGenerator.generateCode(contents, filterName: RSAbstractCodeGenerator.filterName(machineReadableCodeObjectType))
                //let qrr = RSUnifiedCodeGenerator().generateCode(UserPrefs.shared().getCheckedEmail(), machineReadableCodeObjectType: AVMetadataObjectTypeQRCode)
                let qrr = RSAbstractCodeGenerator.generateCode(UserPrefs.shared().getCheckedEmail(), filterName: RSAbstractCodeGenerator.filterName(AVMetadataObjectTypeQRCode))
                let qrScale = RSAbstractCodeGenerator.resizeImage(qrr!, scale: 10)
                qrImageView.image = qrScale
                
                // Setup reset button
                let resetButton = cell.viewWithTag(1003) as! UIButton
                resetButton.addTarget(self, action: "resetQrAccount:", forControlEvents: UIControlEvents.TouchUpInside)
            }
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) 
        }

        return cell
    }
    
    func enterEmailToQr(sender: UIButton!) {
        if (emailField != nil) {
            let emailStr = emailField?.text
            if ((emailStr!).characters.count != 0 && isValidEmail(emailStr!)) {
                UserPrefs.shared().setIsCheckedIn(true)
                UserPrefs.shared().setCheckedEmail(emailStr!)
                tableView.reloadData()
			} else {
				let error = UIAlertView()
				error.title = "Cannot Validate Email"
				error.message = "\(emailStr!) does seem to be a valid email. Perhaps you should try again?"
				error.addButtonWithTitle("OK")
				error.show()
			}
        }
    }
	
	func isValidEmail(testStr:String) -> Bool {
		// println("validate calendar: \(testStr)")
		let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
		
		let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailTest.evaluateWithObject(testStr)
	}
	
    func resetQrAccount(sender: UIButton!) {
        UserPrefs.shared().setIsCheckedIn(false)
        UserPrefs.shared().setCheckedEmail("")
        tableView.reloadData()
    }

}
