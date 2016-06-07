//
//  FirstViewController.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 6/5/16.
//  Copyright © 2016 hayashi311. All rights reserved.
//

import UIKit
import APIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let r = WebAPI.SpeakersRequest()
        APIKit.Session.sendRequest(r) {
            result in
            switch result {
            case let .Success(response):
                print(response)
            case let .Failure(e):
                print(e)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

