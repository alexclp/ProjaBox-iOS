//
//  ChatHelper.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 19/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import Alamofire

class ChatHelper: NSObject {
	
	private class func getHeaders() -> [String: String] {
		let userData = NSUserDefaults.standardUserDefaults().objectForKey("userData")
		let userId = userData!["userId"] as! Int
		let deviceId = userData!["deviceId"] as! Int
		let token = userData!["token"] as! String
		
		return ["Z-UserId": String(userId), "Z-DeviceId": String(deviceId), "Z-Token": token]
	}
	
	class func createChatForUserId(userId: String, completionHandler: (Bool, [String: AnyObject]?) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/chats/recipient/\(userId)"
		let headers = getHeaders()
		
		print("URL for chat: \(urlString)")
		
		Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: headers) .validate() .responseJSON() { response in
			let errorCode = response.result.value!["errorCode"] as! Int
			let data = response.result.value!["data"] as? [String: AnyObject]
			if errorCode != 0 {
				completionHandler(false, nil)
			} else {
				completionHandler(true, data)
			}
		}
	}
	
	class func sendMessage(chatId: String, content: String, completionHandler: (Bool) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/chats/\(chatId)/messages"
		let headers = getHeaders()
		
		Alamofire.request(.POST, urlString, parameters: ["content": content], encoding: .JSON, headers: headers) .validate() .responseJSON() { response in
			let errorCode = response.result.value!["errorCode"] as! Int
			print(response)
			if errorCode != 0 {
				completionHandler(false)
			} else {
				completionHandler(true)
			}
		}
	}
	
	class func getChatList(completionHandler: (Bool, [[String: AnyObject]]?) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/chats"
		let headers = getHeaders()
		
		Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: headers) .validate() .responseJSON() { response in
			let errorCode = response.result.value!["errorCode"] as! Int
			print(response)
			if errorCode != 0 {
				completionHandler(false, nil)
			} else {
				if let data = response.result.value!["data"] {
					if !(data is NSNull) {
						completionHandler(true, (data as! [[String: AnyObject]]))
					}
				}
			}
		}
	}
}
