//
//  Router.swift
//  HackTX
//
//  Created by Drew Romanyk on 9/6/15.
//  Copyright (c) 2015 HackTX. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    static let baseURLString = "https://my.hacktx.com/api"
    
    case Schedule(String)
    case Announcements()
    case Partners()
    case Feedback([String: Int])
    
    var method: Alamofire.Method {
        switch self {
        case .Schedule:
            return .GET
        case .Announcements:
            return .GET
        case .Partners:
            return .GET
        case .Feedback:
            return .POST
        }
    }

    var path: String {
        switch self {
        case .Schedule(let dayId):
            return "/schedule/\(dayId)"
        case .Announcements():
            return "/announcements"
        case .Partners():
            return "/sponsors"
        case .Feedback:
            return "/feedback"
        }
    }
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        switch self {
        case .Feedback(let parameters):
            return ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}
