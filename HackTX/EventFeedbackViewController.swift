//
//  EventFeedbackViewController.swift
//  HackTX
//
//  Created by Drew Romanyk on 9/8/15.
//  Copyright (c) 2015 HackTX. All rights reserved.
//

import UIKit
import Alamofire

class EventFeedbackViewController: UIViewController {
    
	@IBAction func cancelButton(sender: UIBarButtonItem) {
		
		dismissViewControllerAnimated(true, completion: nil)
	}
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    
    @IBOutlet weak var submit: UIButton!
    
    var ratingScore = 5
    var scheduleEvent = Event()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func star1Clicked(sender: UIButton) {
        ratingScore = 1
        star2.imageView?.image = UIImage(named: "partners")
        star3.imageView?.image = UIImage(named: "partners")
        star4.imageView?.image = UIImage(named: "partners")
        star5.imageView?.image = UIImage(named: "partners")
    }
    @IBAction func star2Clicked(sender: UIButton) {
        ratingScore = 2
        star2.imageView?.image = UIImage(named: "partners-filled")
        star3.imageView?.image = UIImage(named: "partners")
        star4.imageView?.image = UIImage(named: "partners")
        star5.imageView?.image = UIImage(named: "partners")
    }
    @IBAction func star3Clicked(sender: UIButton) {
        ratingScore = 3
        star2.imageView?.image = UIImage(named: "partners-filled")
        star3.imageView?.image = UIImage(named: "partners-filled")
        star4.imageView?.image = UIImage(named: "partners")
        star5.imageView?.image = UIImage(named: "partners")
    }
    @IBAction func star4Clicked(sender: UIButton) {
        ratingScore = 4
        star2.imageView?.image = UIImage(named: "partners-filled")
        star3.imageView?.image = UIImage(named: "partners-filled")
        star4.imageView?.image = UIImage(named: "partners-filled")
        star5.imageView?.image = UIImage(named: "partners")
    }
    @IBAction func star5Clicked(sender: UIButton) {
        ratingScore = 5
        star2.imageView?.image = UIImage(named: "partners-filled")
        star3.imageView?.image = UIImage(named: "partners-filled")
        star4.imageView?.image = UIImage(named: "partners-filled")
        star5.imageView?.image = UIImage(named: "partners-filled")
    }
    
    @IBAction func submitClicked(sender: UIButton) {
        let parameters = ["id": scheduleEvent.id!,
                            "rating": ratingScore]
		
		Alamofire.request(Router.Feedback((parameters)))
			.responseJSON{ (request, response, data) in
				if data.isFailure {
					let errorAlert = UIAlertView()
					if errorAlert.title == "" {
						errorAlert.title = "Error"
						errorAlert.message = "Oops! Looks like there was a problem trying to send your feedback."
						errorAlert.addButtonWithTitle("Ok")
						errorAlert.show()
					}
				} else if let data: AnyObject = data.value {
					UserPrefs.shared().setFeedbackEventDone(self.scheduleEvent.id!)
					self.dismissViewControllerAnimated(true, completion: nil)
				}
				
//        Alamofire.request(Router.Feedback(parameters))
//            .responseJSON { (request, response, data, error) in
//                if let anError = error {
//                    let errorAlert = UIAlertView()
//                    if errorAlert.title == "" {
//                        errorAlert.title = "Error"
//                        errorAlert.message = "Oops! Looks like there was a problem trying to send your feedback."
//                        errorAlert.addButtonWithTitle("Ok")
//                        errorAlert.show()
//                    }
//                } else {
//                    UserPrefs.shared().setFeedbackEventDone(self.scheduleEvent.id!)
//                    self.dismissViewControllerAnimated(true, completion: nil)
//                }
//        }
    }
}
}