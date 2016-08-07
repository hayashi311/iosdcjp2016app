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
    let startAt: String
    let time: String
    let room: Room
    let speaker: Speaker?
    let nid: String
    let links: [Link]?
    
    enum Room: String, UnboxableEnum {
        case A = "A"
        case B = "B"

        static func unboxFallbackValue() -> Room {
            return .A
        }
        
        var title: String {
            get {
                return "Track \(rawValue)"
            }
        
        }
    }
    
    struct Link: Unboxable {
        let title: String
        let url: NSURL
        
        init(unboxer: Unboxer) {
            title = unboxer.unbox("title")
            url = unboxer.unbox("url")
        }
    }
    
    init(unboxer: Unboxer) {
        title = unboxer.unbox("title")
        description = unboxer.unbox("description")
        startAt = unboxer.unbox("start_at")
        time = unboxer.unbox("time")
        room = unboxer.unbox("room")
        speaker = unboxer.unbox("speaker")
        let n: Int = unboxer.unbox("nid")
        nid = "\(n)"
        links = unboxer.unbox("links")
    }
}

struct SessionGroup: Unboxable {
    let startAt: String
    let sessions: [Session]
    
    init(unboxer: Unboxer) {
        startAt = unboxer.unbox("start_at")
        sessions = unboxer.unbox("sessions")
    }
}
