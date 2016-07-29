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
	
	class func getUserFullProfile(userId: String, completionHandler: (Bool, [String: AnyObject]?) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/users/\(userId)/profile-full"
		let headers = getHeaders()
		
		Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: headers) .validate() .responseJSON() { response in
			print(response.request)
			let errorCode = response.result.value!["errorCode"] as! Int
			
			if errorCode != 0 {
				completionHandler(false, nil)
			} else {
				let data = response.result.value!["data"] as! [String: AnyObject]
				completionHandler(true, data)
			}
		}
	}
	
	class func getMyFullProfile(completionHandler: (Bool, [String: AnyObject]?) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/my/profile-full"
		let headers = getHeaders()
		
		Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: headers) .validate() .responseJSON() { response in
			print(response)
			let errorCode = response.result.value!["errorCode"] as! Int
			
			if errorCode != 0 {
				completionHandler(false, nil)
			} else {
				let data = response.result.value!["data"] as! [String: AnyObject]
				completionHandler(true, data)
			}
		}
	}
	
	class func updateMyProfile(myProfile: [String: AnyObject], completionHandler: (Bool, [String: AnyObject]?) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/my/profile"
		let headers = getHeaders()
		
		Alamofire.request(.PUT, urlString, parameters: myProfile, encoding: .JSON, headers: headers) .validate() .responseJSON() { response in
			print(response)
			let errorCode = response.result.value!["errorCode"] as! Int
			
			if errorCode != 0 {
				completionHandler(false, nil)
			} else {
				let data = response.result.value!["data"] as! [String: AnyObject]
				completionHandler(true, data)
			}
		}
	}
	
	class func followUser(userId: String, completionHandler: (Bool) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/users/\(userId)/follow"
		let headers = getHeaders()
		
		Alamofire.request(.POST, urlString, parameters: nil, encoding: .JSON, headers: headers) .validate() .responseJSON() { response in
			let errorCode = response.result.value!["errorCode"] as! Int
			if errorCode != 0 {
				print("failed")
				completionHandler(false)
			} else {
				print("success")
				completionHandler(true)
			}
		}
	}
	
	class func unFollowUser(userId: String, completionHandler: (Bool) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/users/\(userId)/follow"
		let headers = getHeaders()
		
		Alamofire.request(.DELETE, urlString, parameters: nil, encoding: .JSON, headers: headers) .validate() .responseJSON() { response in
			let errorCode = response.result.value!["errorCode"] as! Int
			if errorCode != 0 {
				print("failed")
				completionHandler(false)
			} else {
				print("success")
				completionHandler(true)
			}
		}
	}
	
	class func likeUser(userId: String, completionHandler: (Bool) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/users/\(userId)/like"
		let headers = getHeaders()
		
		Alamofire.request(.POST, urlString, parameters: nil, encoding: .JSON, headers: headers) .validate() .responseJSON() { response in
			let errorCode = response.result.value!["errorCode"] as! Int
			if errorCode != 0 {
				print("failed")
				completionHandler(false)
			} else {
				print("success")
				completionHandler(true)
			}
		}
	}
	
	class func unLikeUser(userId: String, completionHandler: (Bool) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/users/\(userId)/like"
		let headers = getHeaders()
		
		Alamofire.request(.DELETE, urlString, parameters: nil, encoding: .JSON, headers: headers) .validate() .responseJSON() { response in
			let errorCode = response.result.value!["errorCode"] as! Int
			if errorCode != 0 {
				print("failed")
				completionHandler(false)
			} else {
				print("success")
				completionHandler(true)
			}
		}
	}
	
	// MARK: POST METHODS
	
	class func getUsersLatestPosts(userId: String, completionHandler: (Bool, [UserPost]?) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/users/\(userId)/feed"
		let headers = getHeaders()
		
		Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: headers) .validate() .responseJSON() { response in
			print(response)
			let errorCode = response.result.value!["errorCode"] as! Int
			
			let data = response.result.value!["data"] as? [[String: AnyObject]]
			
			if let data = data {
				var posts = [UserPost]()
				for post in data {
					let postToAdd = UserPost()
					postToAdd.content = post["content"] as? String
					postToAdd.createdTimestamp = post["created"] as? Int
					postToAdd.id = post["id"] as? Int
					postToAdd.isLikedByMe = post["isLikedByMe"] as? Bool
					postToAdd.image = post["image"] as? String
					postToAdd.video = post["video"] as? NSData
					postToAdd.likers = post["likers"] as? [[String: AnyObject]]
					postToAdd.comments = post["comments"] as? [[String: AnyObject]]
					postToAdd.ownerName = post["ownerName"] as? String
					postToAdd.ownerAvatar = post["ownerAvatar"] as? String
					
					posts.append(postToAdd)
				}
				
				if errorCode != 0 {
					completionHandler(false, nil)
				} else {
					completionHandler(true, posts)
				}
			} else {
				completionHandler(false, nil)
			}
		}
	}
	
	// MARK: PUT METHODS
	
	class func changePassword(newPassword: String, completionHandler: (Bool) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/my/passwd"
		let headers = getHeaders()
		
		Alamofire.request(.PUT, urlString, parameters: ["password": newPassword], encoding: .JSON, headers: headers) .validate() .responseJSON() { response in
			let errorCode = response.result.value!["errorCode"] as! Int
			
			if errorCode != 0 {
				print("failed changing password")
				completionHandler(false)
			} else {
				print("changed password successfully")
				completionHandler(true)
			}
		}
	}
}
