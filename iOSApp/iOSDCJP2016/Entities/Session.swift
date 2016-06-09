//
//  Session.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 6/8/16.
//  Copyright © 2016 hayashi311. All rights reserved.
//

import Foundation
import Unbox

struct Session: Unboxable {
    let title: String
    let description: String
    let time: String
    let room: String
    
    init(unboxer: Unboxer) {
        title = unboxer.unbox("title")
        description = unboxer.unbox("description")
        time = unboxer.unbox("time")
        room = unboxer.unbox("room")
    }
}

struct SessionGroup: Unboxable {
    let time: String
    let sessions: [Session]
    
    init(unboxer: Unboxer) {
        time = unboxer.unbox("time")
        sessions = unboxer.unbox("sessions")
    }
}