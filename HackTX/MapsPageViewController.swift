//
//  MapsPageViewController.swift
//  HackTX
//
//  Created by Gilad Oved on 9/2/15.
//  Copyright (c) 2015 HackTX. All rights reserved.
//

import UIKit

class MapsPageViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.grayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
    }

}
