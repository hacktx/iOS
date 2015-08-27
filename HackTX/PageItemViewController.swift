//
//  PageItemViewController.swift
//  HackTX
//
//  Created by Gilad Oved on 8/27/15.
//  Copyright (c) 2015 HackTX. All rights reserved.
//

import UIKit

class PageItemViewController: UIViewController {

    var itemIndex: Int = 0
    var imageName: String = "" {
        didSet {
            if let imageView = mapImageView {
                imageView.image = UIImage(named: imageName)
            }
        }
    }
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapImageView!.image = UIImage(named: imageName)
        levelLabel.text = "Level \(itemIndex + 1)"
    }

}
