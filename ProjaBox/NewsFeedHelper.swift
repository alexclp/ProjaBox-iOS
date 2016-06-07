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
	
	// MARK: UTILITY METHODS
	
	class func getTimeFromTimestamp(timestamp: Int) -> String {
		let date = NSDate(timeIntervalSince1970: Double(timestamp))
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let calendar = NSCalendar.currentCalendar()
		let comp = calendar.components([.Hour, .Minute], fromDate: date)
		let hour = comp.hour
		let minute = comp.minute
		
		return "\(hour):\(minute)"
	}
	
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
	
	private class func getHeaders() -> [String: String] {
		let userData = NSUserDefaults.standardUserDefaults().objectForKey("userData")
		let userId = userData!["userId"] as! Int
		let deviceId = userData!["deviceId"] as! Int
		let token = userData!["token"] as! String
		
		return ["Z-UserId": String(userId), "Z-DeviceId": String(deviceId), "Z-Token": token]
	}
	
	// MARK: POST RELATED METHODS

	class func getNewsFeed(completionHandler: (Bool, [UserPost]?) -> Void) {
		let userData = NSUserDefaults.standardUserDefaults().objectForKey("userData")
		let userId = userData!["userId"] as! Int
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/users/\(userId)/feed"
		if let url = NSURL(string: urlString) {
			let urlRequest = createAuthHeadersForURL(url, "GET")
			Alamofire.request(urlRequest).responseJSON { response in
				print(response.result.error)
				print(response.result.value)
				
				let errorCode = response.result.value!["errorCode"] as! Int
				let data = response.result.value!["data"] as! [[String: AnyObject]]
				
				var posts = [UserPost]()
				for post in data {
					let type = post["type"] as! String
					if type == "user" {
						let postToAdd = UserPost()
						postToAdd.content = post["content"] as? String
						postToAdd.createdTimestamp = post["created"] as? Int
						postToAdd.id = post["id"] as? Int
						postToAdd.isLikedByMe = post["isLikedByMe"] as? Bool
						postToAdd.image = post["image"] as? NSData
						postToAdd.video = post["video"] as? NSData
						postToAdd.likers = post["likers"] as? [[String: AnyObject]]
						postToAdd.comments = post["comments"] as? [[String: AnyObject]]
						
						posts.append(postToAdd)
					} else {
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
				}
				
				if errorCode != 0 {
					completionHandler(false, nil)
				} else {
					completionHandler(true, posts)
				}
			}
		}
	}
	
	class func createPost(name: String, _ content: String, _ photo: NSData?, _ video: NSData?, completionHandler: (Bool) -> Void) {
		if let image = photo, let video = video {
			let parameters: [String: AnyObject] = ["name": name, "content": content, "image": image, "video": video]
			let headers = getHeaders()
			Alamofire.request(.POST, "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/posts", parameters: parameters, encoding: .JSON, headers: headers) .validate() .responseJSON { response in
				
				print(response)
				
				let errorCode = response.result.value!["errorCode"] as! Int
				if errorCode != 0 {
					completionHandler(false)
				} else {
					completionHandler(true)
				}
			}
		} else {
			let headers = getHeaders()
			Alamofire.request(.POST, "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/posts", parameters: ["name": name, "content": content], encoding: .JSON, headers: headers) .validate() .responseJSON { response in
				
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
	
	// MARK: LIKE METHODS
	
	class func likePost(postId: String, completionHandler: (Bool) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/posts/\(postId)/like"
		let headers = getHeaders()
		
		Alamofire.request(.POST, urlString, parameters: nil, encoding: .JSON, headers: headers) .validate() .responseJSON { response in
			print(response)
			let errorCode = response.result.value!["errorCode"] as! Int
			if errorCode != 0 {
				completionHandler(false)
			} else {
				completionHandler(true)
			}
		}
	}
	
	class func unlikePost(postId: String, completionHandler: (Bool) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/posts/\(postId)/like"
		let headers = getHeaders()
		
		Alamofire.request(.DELETE, urlString, parameters: nil, encoding: .JSON, headers: headers) .validate() .responseJSON { response in
			let errorCode = response.result.value!["errorCode"] as! Int
			if errorCode != 0 {
				completionHandler(false)
			} else {
				completionHandler(true)
			}
		}
	}
	
	// MARK: COMMENT METHODS
	
	class func createComment(postId: String, commentContent: String, completionHandler: (Bool) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/posts/\(postId)/comments"
		let headers = getHeaders()
		let parameters = ["content": commentContent]
		
		Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON, headers: headers) .validate() .responseJSON { response in
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
