//
//  ProfileHelper.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 08/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import Alamofire

class ProfileHelper: NSObject {

	// MARK: UTILITY METHODS
	
	private class func getHeaders() -> [String: String] {
		let userData = NSUserDefaults.standardUserDefaults().objectForKey("userData")
		let userId = userData!["userId"] as! Int
		let deviceId = userData!["deviceId"] as! Int
		let token = userData!["token"] as! String
		
		return ["Z-UserId": String(userId), "Z-DeviceId": String(deviceId), "Z-Token": token]
	}
	
	// MARK: PROFILE METHODS
	
	class func getMyFullProfile(completionHandler: (Bool) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/my/profile-full"
		let headers = getHeaders()
		
		Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: headers) .validate() .responseJSON() { response in
			print(response)
		}
	}
	
}
