//
//  NotificationService.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 6/14/16.
//  Copyright © 2016 hayashi311. All rights reserved.
//

import Foundation
import AirshipKit

class NotificationService {
    static let sharedInstance = NotificationService()
    
    private init() {
        UAirship.takeOff()
    }
    
    func connect() {
        UAirship.push().userPushNotificationsEnabled = true
        UAirship.push().autobadgeEnabled = true
        UAirship.push().resetBadge()
        UAirship.inAppMessaging().displayDelay = 5
        UAirship.inAppMessaging().displayASAPEnabled = true
        UAirship.shared().analytics.enabled = false
    }
}
