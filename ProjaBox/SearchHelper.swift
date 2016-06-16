//
//  SearchHelper.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 16/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import Alamofire

class SearchHelper: NSObject {
	
	private class func getHeaders() -> [String: String] {
		let userData = NSUserDefaults.standardUserDefaults().objectForKey("userData")
		let userId = userData!["userId"] as! Int
		let deviceId = userData!["deviceId"] as! Int
		let token = userData!["token"] as! String
		
		return ["Z-UserId": String(userId), "Z-DeviceId": String(deviceId), "Z-Token": token]
	}
	
	class func searchForProjects(queryString: String, completionHandler: (Bool, [Project]?) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/search/projects/\(queryString)"
		let headers = getHeaders()
		
		Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: headers) .validate() .responseJSON() { response in
			let errorCode = response.result.value!["errorCode"] as! Int
			let data = response.result.value!["data"] as? [[String: AnyObject]]
			
			if let data = data {
				var results = [Project]()
				for result in data {
					let currentProject = Project()
					currentProject.name = result["name"] as? String
					currentProject.id = result["id"] as? Int
					currentProject.type = result["type"] as? String
					currentProject.desc = result["description"] as? String
					currentProject.jobs = result["jobs"] as? [String]
					currentProject.location = result["location"] as? String
					currentProject.isLikedByMe = result["isLikedByMe"] as? Bool
					currentProject.likers = result["likers"] as? [[String: AnyObject]]
					
					results.append(currentProject)
				}
				
				if errorCode != 0 {
					completionHandler(false, nil)
				} else {
					completionHandler(true, results)
				}
			}
		}
	}
	
	class func searchForUsers(queryString: String, completionHandler: (Bool, [User]?) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/search/peoples/\(queryString)"
		let headers = getHeaders()
		
		Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: headers) .validate() .responseJSON() { response in
			let errorCode = response.result.value!["errorCode"] as! Int
			let data = response.result.value!["data"] as? [[String: AnyObject]]
			
			if let data = data {
				var results = [User]()
				for result in data {
					let currentUser = User()
					currentUser.id = result["id"] as? Int
					currentUser.name = result["name"] as? String
					currentUser.location = result["location"] as? String
					currentUser.likers = result["likers"] as? [[String: AnyObject]]
					currentUser.about = result["about"] as? String
					currentUser.status = result["status"] as? String
					
					results.append(currentUser)
				}
				
				if errorCode != 0 {
					completionHandler(false, nil)
				} else {
					completionHandler(true, results)
				}
			}
		}
	}
}
