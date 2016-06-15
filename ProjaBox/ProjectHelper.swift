//
//  ProjectHelper.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 13/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import Alamofire

class ProjectHelper: NSObject {

	// MARK: UTILITY METHODS
	
	private class func getHeaders() -> [String: String] {
		let userData = NSUserDefaults.standardUserDefaults().objectForKey("userData")
		let userId = userData!["userId"] as! Int
		let deviceId = userData!["deviceId"] as! Int
		let token = userData!["token"] as! String
		
		return ["Z-UserId": String(userId), "Z-DeviceId": String(deviceId), "Z-Token": token]
	}
	
	// MAR: CREATING
	
	class func createProject(projectData: [String: AnyObject], completionHandler: (Bool, [String: AnyObject]?) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/projects"
		let headers = getHeaders()
		
		Alamofire.request(.POST, urlString, parameters: projectData, encoding: .JSON, headers: headers) .validate() .responseJSON() { response in
			
			let errorCode = response.result.value!["errorCode"] as! Int
			
			if errorCode != 0 {
				completionHandler(false, nil)
			} else {
				let data = response.result.value!["data"] as! [String: AnyObject]
				print(data)
				completionHandler(true, data)
			}
		}
	}
	
	class func createProjectTeamMate(projectId: String, teammate: [String: String], completionHandler: (Bool) -> Void) {
		let urlString =  "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/projects/\(projectId)/team"
		let headers = getHeaders()
		
		Alamofire.request(.POST, urlString, parameters: teammate, encoding: .JSON, headers: headers) .validate() .responseJSON() { response in
			print(response.response)
			let errorCode = response.result.value!["errorCode"] as! Int
			
			if errorCode != 0 {
				completionHandler(false)
			} else {
				completionHandler(true)
			}
		}
	}
	
	class func createPost(projectId: String, _ name: String, _ content: String, _ photo: NSData?, _ video: NSData?, completionHandler: (Bool) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/projects/\(projectId)/posts"
		let headers = getHeaders()
		if let image = photo, let video = video {
			let parameters: [String: AnyObject] = ["name": name, "content": content, "image": image, "video": video]
			Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON, headers: headers) .validate() .responseJSON { response in
				
				//				print(response)
				
				let errorCode = response.result.value!["errorCode"] as! Int
				if errorCode != 0 {
					completionHandler(false)
				} else {
					completionHandler(true)
				}
			}
		} else {
			Alamofire.request(.POST, urlString, parameters: ["name": name, "content": content], encoding: .JSON, headers: headers) .validate() .responseJSON { response in
				
				//				print(response)
				
				let errorCode = response.result.value!["errorCode"] as! Int
				if errorCode != 0 {
					completionHandler(false)
				} else {
					completionHandler(true)
				}
			}
		}
	}
	
	// MARK: FETCHING
	
	class func getFullProjectProfile(projectId: String, completionHandler: (Bool, [String: AnyObject]?) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/projects/\(projectId)"
		let headers = getHeaders()
		
		Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: headers) .validate() .responseJSON() { response in
			let errorCode = response.result.value!["errorCode"] as! Int
			
			if errorCode != 0 {
				completionHandler(false, nil)
			} else {
				let data = response.result.value!["data"] as! [String: AnyObject]
//				print(data)
				completionHandler(true, data)
			}
		}
	}
	
	class func getProjectsLatestPosts(projectId: String, completionHandler: (Bool, [ProjectPost]?) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/projects/\(projectId)/latest"
		print("URL: \(urlString)")
		let headers = getHeaders()
		
		Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: headers) .validate() .responseJSON() { response in
			print("RESPONSE: \(response)")
			let errorCode = response.result.value!["errorCode"] as! Int
			let data = response.result.value!["data"] as? [[String: AnyObject]]
			
			if let data = data {
				var posts = [ProjectPost]()
				for post in data {
					let postToAdd = ProjectPost()
					postToAdd.content = post["content"] as? String
					postToAdd.createdTimestamp = post["created"] as? Int
					postToAdd.id = post["id"] as? Int
					postToAdd.isLikedByMe = post["isLikedByMe"] as? Bool
					postToAdd.image = post["image"] as? NSData
					postToAdd.video = post["video"] as? NSData
					
					postToAdd.projectAvatar = post["projectAvatar"] as? NSData
					postToAdd.projectId = post["projectId"] as? Int
					postToAdd.projectName = post["projectName"] as? String
					postToAdd.projectOwnerId = post["projectOwnerId"] as? Int
					postToAdd.likers = post["likers"] as? [[String: AnyObject]]
					postToAdd.comments = post["comments"] as? [[String: AnyObject]]
					
					posts.append(postToAdd)
				}
				
				if errorCode != 0 {
					completionHandler(false, nil)
				} else {
					completionHandler(true, posts)
				}
		}

		}
	}
	
	// MARK: UPDATING
	
	class func updateProjectProfile(projectId: String, fullProfileData: [String: AnyObject], completionHandler: (Bool) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/projects/\(projectId)"
		let headers = getHeaders()
		
		print("Data: \(fullProfileData)")
		
		Alamofire.request(.PUT, urlString, parameters: fullProfileData, encoding: .JSON, headers: headers) .validate() .responseJSON() { response in
			print(response)
			let errorCode = response.result.value!["errorCode"] as! Int
			
			if errorCode != 0 {
				completionHandler(false)
			} else {
				completionHandler(true)
			}
		}
	}
}
