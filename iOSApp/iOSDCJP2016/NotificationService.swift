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
    }
}
