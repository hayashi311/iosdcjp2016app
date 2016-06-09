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

protocol IOSDCRequestType: RequestType {
    
}

extension IOSDCRequestType {
    var baseURL: NSURL {
        return NSURL(string: "http://127.0.0.1:5000")!
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
}


struct SessionsResponse: Unboxable  {
    let sessions: [Session]
    
    init(unboxer: Unboxer) {
        sessions = unboxer.unbox("sessions")
    }
}


struct SpeakersResponse: Unboxable  {
    let speakers: [Speaker]
    
    init(unboxer: Unboxer) {
        speakers = unboxer.unbox("speakers")
    }
}
