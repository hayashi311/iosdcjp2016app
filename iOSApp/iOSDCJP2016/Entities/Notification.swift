//
//  Notification.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 7/2/16.
//  Copyright © 2016 hayashi311. All rights reserved.
//

import Foundation
import Unbox

struct Notification: Unboxable {
    let createdAt: NSDate
    let image: String?
    let message: String
    let url: String?

    init(unboxer: Unboxer) {
        let unixtime: NSTimeInterval = unboxer.unbox("created_at")
        createdAt = NSDate(timeIntervalSince1970: unixtime)
        image = unboxer.unbox("image")
        message = unboxer.unbox("message")
        url = unboxer.unbox("url")
    }
}
