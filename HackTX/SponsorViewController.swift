//
//  CollectionViewController.swift
//  HackTX
//
//  Created by Andrew Romanyk on 8/23/15.
//  Copyright (c) 2015 HackTX. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class SponsorViewController: UICollectionViewController {
    
    var sponsorList = [Sponsor]()
    var imageCache = [String:UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.registerNib(UINib(nibName: "SponsorViewCell", bundle: nil), forCellWithReuseIdentifier: "SponsorCell")
        
        let endpoint = "https://my.hacktx.com/api/sponsors"
        request(.GET, endpoint)
            .responseJSON { (request, response, data, error) in
                if let anError = error {
//                    if errorAlert.title == "" {
//                        errorAlert.title = "Error"
//                        errorAlert.message = "Oops! Looks like there was a problem trying to get the announcements"
//                        errorAlert.addButtonWithTitle("Ok")
//                        errorAlert.show()
//                    }
                } else {
                    let json = JSON(data!)
                    self.sponsorList.removeAll(keepCapacity: true)
                    
                    for (index: String, subJson: JSON) in json {
                        self.sponsorList.append(Sponsor(name: subJson["name"].stringValue, logoImage: subJson["logoImage"].stringValue, website: subJson["website"].stringValue, level: subJson["level"].intValue))
                    }
                    
                    self.collectionView!.reloadData()
                }
        }

    }
    
    // Setup Google Analytics for the controller
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Sponsors")
        
        var builder = GAIDictionaryBuilder.createScreenView()
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SponsorCell", forIndexPath: indexPath) as! SponsorViewCell
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
                    let image = UIImage(data: data)
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
                    println("Error: \(error.localizedDescription)")
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
            size = CGSize(width: view.frame.width - 20, height: 150)
        case 1:
            size = CGSize(width: view.frame.width - 20, height: 150)
        case 2:
            size = CGSize(width: (view.frame.width/2.3)-10, height: 100)
        default:
            size = CGSize(width: (view.frame.width/2.3)-10, height: 100)
            
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

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
