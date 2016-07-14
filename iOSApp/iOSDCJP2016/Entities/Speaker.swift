//
//  Speaker.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 6/8/16.
//  Copyright © 2016 hayashi311. All rights reserved.
//

import Foundation
import Unbox

struct Speaker: Unboxable {
    let name: String
    let company: String?
    let twitterAccount: String?
    let image: String
//    let session: Session?
    
    init(unboxer: Unboxer) {
        name = unboxer.unbox("name")
        twitterAccount = unboxer.unbox("twitter_account")
        image = unboxer.unbox("image")
        company = unboxer.unbox("company")
//        session = unboxer.unbox("session")
    }
}
