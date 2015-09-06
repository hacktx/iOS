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
    
    var method: Alamofire.Method {
        switch self {
        case .Schedule:
            return .GET
        case .Announcements:
            return .GET
        case .Partners:
            return .GET
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
        }
    }
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSURLRequest {
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        switch self {
        default:
            return mutableURLRequest
        }
    }
}
