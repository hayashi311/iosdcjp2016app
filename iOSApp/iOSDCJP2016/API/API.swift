//
//  IOSDCRequestType.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 6/6/16.
//  Copyright © 2016 hayashi311. All rights reserved.
//

import Foundation
import APIKit
import Unbox

let APIBaseURL = "http://iosdc.herokuapp.com"

protocol IOSDCRequestType: RequestType {
    
}

extension IOSDCRequestType {
    var baseURL: NSURL {
        return NSURL(string: APIBaseURL)!
    }
}

extension IOSDCRequestType where Response: Unboxable {
    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) throws -> Response {
        guard let dict = object as? UnboxableDictionary,
            let response: Response = try? Unbox(dict) else {
            throw ResponseError.UnexpectedObject(object)
        }
        return response
    }
}

final class WebAPI {
    struct SessionsRequest: IOSDCRequestType {
        typealias Response = SessionsResponse

        var method: HTTPMethod {
            return .GET
        }
        
        var path: String {
            return "/sessions"
        }
    }

    struct SpeakersRequest: IOSDCRequestType {
        typealias Response = SpeakersResponse

        var method: HTTPMethod {
            return .GET
        }
        
        var path: String {
            return "/speakers"
        }
    }

    struct NotificationsRequest: IOSDCRequestType {
        typealias Response = NotificationsResponse

        var method: HTTPMethod {
            return .GET
        }
        
        var path: String {
            return "/notifications"
        }
    }

    struct WifiRequest: IOSDCRequestType {
        typealias Response = NotificationsResponse

        var method: HTTPMethod {
            return .GET
        }
        
        var path: String {
            return "/misc/wifi"
        }
    }
}


struct SessionsResponse: Unboxable  {
    let schedule: [SessionGroup]
    
    init(unboxer: Unboxer) {
        schedule = unboxer.unbox("schedule")
    }
}


struct SpeakersResponse: Unboxable  {
    let speakers: [Speaker]
    
    init(unboxer: Unboxer) {
        speakers = unboxer.unbox("speakers")
    }
}

struct NotificationsResponse: Unboxable {
    let notifications: [Notification]
    init(unboxer: Unboxer) {
        notifications = unboxer.unbox("notifications")
    }
}

struct WifiResponse: Unboxable {
    let network: String
    let password: String

    init(unboxer: Unboxer) {
        network = unboxer.unbox("wifi.network", isKeyPath: true)
        password = unboxer.unbox("wifi.password", isKeyPath: true)
    }
}
