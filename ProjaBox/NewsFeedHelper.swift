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

	class func getNewsFeed() {
		let userData = NSUserDefaults.standardUserDefaults().objectForKey("userData")
		let userId = userData!["userId"] as! Int
		let deviceId = userData!["deviceId"] as! Int
		let token = userData!["token"] as! String
		
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/users/\(userId)/feed"
		if let url = NSURL(string: urlString) {
			let URLRequest = NSMutableURLRequest(URL: url)
			URLRequest.setValue(String(userId), forHTTPHeaderField: "Z-UserId")
			URLRequest.setValue(String(deviceId), forHTTPHeaderField: "Z-DeviceId")
			URLRequest.setValue(token, forHTTPHeaderField: "Z-Token")
			
			URLRequest.HTTPMethod = "GET"
			Alamofire.request(URLRequest).responseJSON { response in
				print(response.result.error)
				print(response.result.value)
			}
		}
	}
	
}
