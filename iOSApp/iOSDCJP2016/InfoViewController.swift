//
//  InfoViewController.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 6/14/16.
//  Copyright © 2016 hayashi311. All rights reserved.
//

import UIKit

class InfoViewController: UITableViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wifiTitleLabel: UILabel!
    @IBOutlet weak var wifiPasswordTitleLabel: UILabel!
    @IBOutlet weak var wifiLabel: UILabel!
    @IBOutlet weak var wifiPasswordLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.attributedText = NSAttributedString(string: "WIFI :)", style: .Title)
        wifiTitleLabel.attributedText = NSAttributedString(string: "NETWORK", style: .Body) {
            builder in
            builder.color = UIColor.secondaryTextColor()
        }
        wifiPasswordTitleLabel.attributedText = NSAttributedString(string: "PASSWORD", style: .Body) {
            builder in
            builder.color = UIColor.secondaryTextColor()
        }
        wifiLabel.attributedText = NSAttributedString(string: "iosdc", style: .Body)
        wifiPasswordLabel.attributedText = NSAttributedString(string: "cookpad-yeah!", style: .Body)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
