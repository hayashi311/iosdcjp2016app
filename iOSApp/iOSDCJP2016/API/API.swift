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

    var method: HTTPMethod {
        return .GET
    }

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

        var path: String {
            return "/sessions"
        }
    }

    struct SpeakersRequest: IOSDCRequestType {
        typealias Response = SpeakersResponse
        
        var path: String {
            return "/speakers"
        }
    }

    struct NotificationsRequest: IOSDCRequestType {
        typealias Response = NotificationsResponse
        
        var path: String {
            return "/notifications"
        }
    }

    struct WifiRequest: IOSDCRequestType {
        typealias Response = WifiResponse

        var path: String {
            return "/misc/wifi"
        }
    }

    struct SponsorsRequest: IOSDCRequestType {
        typealias Response = SponsorsResponse

        var path: String {
            return "/misc/sponsors"
        }
    }
    
    struct VoteRequest: RequestType {
        typealias Response = VoteResponse
        
        let ono: String
        let nid: String
        
        var baseURL: NSURL {
            return NSURL(string: "https://iosdc.jp")!
        }

        var path: String {
            return "/2016/c/api/vote/\(ono)/\(nid)/"
        }
        
        var method: HTTPMethod {
            return .GET
        }

        var dataParser: DataParserType {
            get {
                return JSONDataParser(readingOptions: .AllowFragments)
            }
        }

//        var queryParameters: [String : AnyObject]? {
//            print(self)
//            return [
//                "ono": ono,
//                "nid": nid
//            ]
//        }
        
        func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) throws -> VoteResponse {
            print(object)
            guard let dict = object as? UnboxableDictionary,
                let response: VoteResponse = try? Unbox(dict) else {
                throw ResponseError.UnexpectedObject(object)
            }
            return response
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

struct SponsorsResponse: Unboxable {
    let tiers: [SponsorTier]
    init(unboxer: Unboxer) {
        tiers = unboxer.unbox("tiers")
    }
}

struct VoteResponse: Unboxable {
    enum Result: String, UnboxableEnum {
        case OK = "ok"
        case Error = "error"
        
        static func unboxFallbackValue() -> Result {
            return .Error
        }
    }
    
    let result: Result
    let nid: String
    let voted: Bool
    
    init(unboxer: Unboxer) {
        result = unboxer.unbox("result")
        nid = unboxer.unbox("nid")
        voted = unboxer.unbox("voted")
    }
}
