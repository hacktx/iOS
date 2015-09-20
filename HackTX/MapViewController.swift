//
//  MapViewController.swift
//  HackTX
//
//  Created by Rohit Datta on 7/11/15.
//  Copyright (c) 2015 HackTX. All rights reserved.
//

import Foundation
import UIKit

class MapViewController: UIViewController, UIPageViewControllerDataSource {
	
    let mapImages = [["sac1", "sac2", "sac3"], ["cla1"]];
    var mapIndex = 0
    var pageViewController: UIPageViewController?
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageController") as! UIPageViewController
        pageController.dataSource = self
        
        if mapImages[mapIndex].count > 0 {
            let startingViewControllers: NSArray = [getItemController(0)!]
            pageController.setViewControllers(startingViewControllers as! [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        pageViewController!.view.frame = CGRectMake(15, -50, pageViewController!.view.frame.size.width-30, pageViewController!.view.frame.size.height)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
        
    }
    
    // Setup Google Analytics for the controller
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Maps")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    func updatePageView() {
        if mapImages[mapIndex].count > 0 {
            let startingViewControllers: NSArray = [getItemController(0)!]
            self.pageViewController?.setViewControllers(startingViewControllers as! [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
    }
	
    private func getItemController(itemIndex: Int) -> PageItemViewController? {
        if itemIndex < mapImages[mapIndex].count && mapImages[mapIndex].count > 0 {
            let pageItemController = self.storyboard?.instantiateViewControllerWithIdentifier("ItemController") as! PageItemViewController
            pageItemController.itemIndex = itemIndex
            pageItemController.imageName = mapImages[mapIndex][itemIndex]
            return pageItemController
        }
        
        return nil
    }
	
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemViewController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemViewController
        
        if itemController.itemIndex + 1 < mapImages[mapIndex].count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }

    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return mapImages[mapIndex].count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    @IBAction func updateMap(sender: AnyObject) {
        if mapIndex == 0 {
            mapIndex = 1
        } else {
            mapIndex = 0
        }
        updatePageView()
    }
}
