//
//  AppDelegate.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 6/5/16.
//  Copyright © 2016 hayashi311. All rights reserved.
//

import UIKit
import URLNavigator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UINavigationBar.appearance().tintColor = UIColor.accentColor()
        NotificationService.sharedInstance.connect()
        Navigator.map("iosdc://vote/<nid>") {
            (URL, values) -> Bool in
            guard let c = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("VoteCodeInputViewController") as? VoteCodeInputViewController else {
                return false
            }
            c.nid = values["nid"] as! String
            Navigator.push(c)
            return true
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) { }

    func applicationDidEnterBackground(application: UIApplication) { }

    func applicationWillEnterForeground(application: UIApplication) { }

    func applicationDidBecomeActive(application: UIApplication) { }

    func applicationWillTerminate(application: UIApplication) { }
}

