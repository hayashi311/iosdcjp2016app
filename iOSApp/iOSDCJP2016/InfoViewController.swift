//
//  InfoViewController.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 6/14/16.
//  Copyright © 2016 hayashi311. All rights reserved.
//

import UIKit
import APIKit

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

        wifiLabel.text = nil
        wifiPasswordLabel.text = nil

        let r = WebAPI.WifiRequest()
        APIKit.Session.sendRequest(r) {
            [weak self] result in
            guard let s = self else { return }
            switch result {
            case let .Success(response):
                s.wifiLabel.attributedText = NSAttributedString(string: response.network, style: .Body)
                s.wifiPasswordLabel.attributedText = NSAttributedString(string: response.password, style: .Body)
            case let .Failure(e):
                print(e)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
