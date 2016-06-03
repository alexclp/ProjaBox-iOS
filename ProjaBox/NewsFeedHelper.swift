//
//  NewsFeedHelper.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 03/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

import Alamofire

class NewsFeedHelper: NSObject {
	
	private class func createAuthHeadersForURL(URL: NSURL, _ httpMethod: String) -> NSURLRequest {
		let userData = NSUserDefaults.standardUserDefaults().objectForKey("userData")
		let userId = userData!["userId"] as! Int
		let deviceId = userData!["deviceId"] as! Int
		let token = userData!["token"] as! String
		
		let mutableURLRequest = NSMutableURLRequest(URL: URL)
		mutableURLRequest.setValue(String(userId), forHTTPHeaderField: "Z-UserId")
		mutableURLRequest.setValue(String(deviceId), forHTTPHeaderField: "Z-DeviceId")
		mutableURLRequest.setValue(token, forHTTPHeaderField: "Z-Token")
		mutableURLRequest.HTTPMethod = httpMethod
		
		return mutableURLRequest
	}

	class func getNewsFeed() {
		let userData = NSUserDefaults.standardUserDefaults().objectForKey("userData")
		let userId = userData!["userId"] as! Int
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/users/\(userId)/feed"
		if let url = NSURL(string: urlString) {
			let urlRequest = createAuthHeadersForURL(url, "GET")
			Alamofire.request(urlRequest).responseJSON { response in
				print(response.result.error)
				print(response.result.value)
			}
		}
	}
	
	class func createPost(name: String, _content: String, photo: NSData?, video: NSData?) {
		if let url = NSURL(string: "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/posts") {
			let urlRequest = createAuthHeadersForURL(url, "POST")
			
			let manager = Alamofire.Manager.sharedInstance
			let request = manager.request(urlRequest)
			request.responseJSON(completionHandler: { (response) in
				print(response)
			})
		}
	}
	
}
