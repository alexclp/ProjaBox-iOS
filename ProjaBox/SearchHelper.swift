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
		var urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/search/projects/\(queryString)"
		urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
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
					currentProject.avatar = result["avatar"] as? String
					
					results.append(currentProject)
				}
				
				if errorCode != 0 {
					completionHandler(false, nil)
				} else {
					completionHandler(true, results)
				}
			} else {
				completionHandler(false, nil)
			}
		}
	}
	
	class func searchForUsers(queryString: String, completionHandler: (Bool, [User]?) -> Void) {
		var urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/search/peoples/\(queryString)"
		urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
		let headers = getHeaders()
		
		print("will search for name: \(urlString)")
		
		Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: headers) .validate() .responseJSON() { response in
			print(response)
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
					currentUser.avatar = result["avatar"] as? String
					currentUser.position = result["position"] as? String
					
					results.append(currentUser)
				}
				
				if errorCode != 0 {
					completionHandler(false, nil)
				} else {
					completionHandler(true, results)
				}
			} else {
				completionHandler(false, nil)
			}
		}
	}
	
	class func getLatestProjects(completionHandler: (Bool, [Project]?) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/search/stream/projects/latest"
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
					currentProject.isFollowed = result["isFollowedByMe"] as? Bool
					currentProject.avatar = result["avatar"] as? String
					
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
	
	class func getLatestUsers(completionHandler: (Bool, [User]?) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/search/stream/peoples/latest"
		let headers = getHeaders()
		
		Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: headers) .validate() .responseJSON() { response in
			let errorCode = response.result.value!["errorCode"] as! Int
			let data = response.result.value!["data"] as? [[String: AnyObject]]
			print("Latest users: \(response)")
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
					currentUser.isFollowed = result["isFollowedByMe"] as? Bool
					currentUser.isLikedByMe = result["isLikedByMe"] as? Bool
					currentUser.avatar = result["avatar"] as? String
					
					results.append(currentUser)
				}
				
				if errorCode != 0 {
					completionHandler(false, nil)
				} else {
					completionHandler(true, results)
				}
			} else {
				completionHandler(true, nil)
			}
		}
	}
}
