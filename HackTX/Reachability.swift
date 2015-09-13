//
//  Reachability.swift
//  HackTX
//
//  Created by Rohit Datta on 9/13/15.
//  Copyright (c) 2015 HackTX. All rights reserved.
//

import Foundation

public class Reachability {
	
	class func isConnectedToNetwork()->Bool{
		
		var Status:Bool = false
		let url = NSURL(string: "http://google.com/")
		let request = NSMutableURLRequest(URL: url!)
		request.HTTPMethod = "HEAD"
		request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
		request.timeoutInterval = 10.0
		
		var response: NSURLResponse?
		
		var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil) as NSData?
		
		if let httpResponse = response as? NSHTTPURLResponse {
			if httpResponse.statusCode == 200 {
				Status = true
			}
		}
		
		return Status
	}
}