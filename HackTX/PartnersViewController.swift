//
//  CollectionViewController.swift
//  HackTX
//
//  Created by Drew Romanyk on 8/23/15.
//  Copyright (c) 2015 HackTX. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PartnersViewController: UICollectionViewController {
    
    let reuseIdCell = "PartnersCell"
    
    var sponsorList = [Sponsor]()
    var imageCache = [String:UIImage]()
	var refreshControl: UIRefreshControl!
	let reachability = Reachability.reachabilityForInternetConnection()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.registerNib(UINib(nibName: "PartnersViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdCell)
		
		
		self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor(red: 125/255.0, green: 211/255.0, blue: 244/255.0, alpha: 1.0)
		self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
		self.collectionView!.addSubview(refreshControl)
		
		if (reachability?.whenReachable != nil) {
			print("Internet connection OK")
			getPartnersData()
		} else {
			print("Internet connection FAILED")
			var alert = UIAlertView(title: "No Internet Connection", message: "The HackTX app requires an internet connection to work. Talk to a volunteer about getting Internet access.", delegate: nil, cancelButtonTitle: "OK")
			alert.show()
		}
		
    }
    
	func refresh(sender: AnyObject) {
		if (reachability?.whenReachable != nil) {
			print("Internet connection OK")
			getPartnersData()
		} else {
			print("Internet connection FAILED")
			var alert = UIAlertView(title: "No Internet Connection", message: "The HackTX app requires an internet connection to work. Talk to a volunteer about getting Internet access.", delegate: nil, cancelButtonTitle: "OK")
			alert.show()
		}
		self.refreshControl.endRefreshing()
	}
	
    func getPartnersData() {
		Alamofire.request(Router.Partners())
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
					print("\n\nJSON HERE:\n\(data)")
					let json = JSON(data)
					self.sponsorList.removeAll(keepCapacity: true)
					
					for (index, subJson): (String, JSON) in json {
						self.sponsorList.append(Sponsor(name: subJson["name"].stringValue, logoImage: subJson["logoImage"].stringValue, website: subJson["website"].stringValue, level: subJson["level"].intValue))
					}
					
					self.collectionView!.reloadData()
				}
				
		}
		
		
		
//		
//		
//        Alamofire.request(Router.Partners())
//            .responseJSON { (request, response, data, error) in
//                if let anError = error {
//                    //                    if errorAlert.title == "" {
//                    //                        errorAlert.title = "Error"
//                    //                        errorAlert.message = "Oops! Looks like there was a problem trying to get the announcements"
//                    //                        errorAlert.addButtonWithTitle("Ok")
//                    //                        errorAlert.show()
//                    //                    }
//                } else {
//                    println("\n\nJSON HERE:\n\(data)")
//                    let json = JSON(data!)
//                    self.sponsorList.removeAll(keepCapacity: true)
//                    
//                    for (index, subJson): (String, JSON) in json {
//                        self.sponsorList.append(Sponsor(name: subJson["name"].stringValue, logoImage: subJson["logoImage"].stringValue, website: subJson["website"].stringValue, level: subJson["level"].intValue))
//                    }
//                    
//                    self.collectionView!.reloadData()
//                }
//        }
    }
    
    // Setup Google Analytics for the controller
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Sponsors")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return sponsorList.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdCell, forIndexPath: indexPath) as! PartnersViewCell
        let sponsor = sponsorList[indexPath.row]
        
//        cell.backgroundImage.image = UIImage(named: "transparent")
        if let img = imageCache[sponsor.logoImage] {
            cell.sponsorImage.image = img
        } else {
            let image_link_url = NSURL(string: sponsor.logoImage)
            // The image isn't cached, download the img data
            // We should perform this in a background thread
            let request: NSURLRequest = NSURLRequest(URL: image_link_url!)
            let mainQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    // Convert the downloaded data in to a UIImage object
                    let image = UIImage(data: data!)
                    // Store the image in to our cache
                    self.imageCache[sponsor.logoImage] = image
                    // Update the cell
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = self.collectionView!.cellForItemAtIndexPath(indexPath) {
                            cell.sponsorImage.image = self.imageCache[sponsor.logoImage]
                        }
                    })
                }
                else {
                    print("Error: \(error!.localizedDescription)")
                }
            })
        }
    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let currentSponsor = sponsorList[indexPath.item]
        let level = currentSponsor.level
        
        var size : CGSize
        
        switch level{
        case 0:
            size = CGSize(width: view.frame.width, height: 100)
        case 1:
            size = CGSize(width: view.frame.width, height: 100)
        case 2:
            size = CGSize(width: (view.frame.width/2)-10, height: 100)
        default:
            size = CGSize(width: (view.frame.width/2)-10, height: 100)
            
        }
        return size
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let sponsor = sponsorList[indexPath.row]
        
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"googlechrome-x-callback://")!)) {
            openInChrome(sponsor.website)
        } else {
            UIApplication.sharedApplication().openURL(NSURL(string: sponsor.website)!)
        }
    }
    
    func openInChrome(url: String) {
        var urlString = url
        if(!urlString.hasPrefix("http")) {
            urlString = "http://" + urlString
        }
        
        UIApplication.sharedApplication().openURL(NSURL(string:
            "googlechrome-x-callback://x-callback-url/open/?x-source=HackTX&x-success=hacktx%3A%2F%2F&url=" + urlString + "&create-new-tab")!)
    }

}
