//
//  NSUserDefault+VodeCode.swift
//  iOSDCJP2016
//
//  Created by Ryota Hayashi on 2016/07/14.
//  Copyright © 2016年 hayashi311. All rights reserved.
//

import Foundation


extension NSUserDefaults {
    var vodeCode: String? {
        get {
            return objectForKey("voteCode") as? String
        }
        set {
            setObject(newValue, forKey: "vodeCode")
        }
    }
}
