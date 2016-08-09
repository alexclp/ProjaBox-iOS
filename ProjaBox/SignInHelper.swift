//
//  SignInHelper.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 02/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import Alamofire

class SignInHelper: NSObject {
	
	class func signUpFirstStep(emailAddress: String, completionHandler: (Bool) -> Void) {
		let parameters: [String: String] = ["email": emailAddress]
		
		Alamofire.request(.POST, "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/auth/signup", parameters: parameters, encoding: .JSON, headers: nil) .validate() .responseJSON { response in
			
			print(response)
			
			let errorCode = response.result.value!["errorCode"] as! Int
			if errorCode != 0 {
				completionHandler(false)
			} else {
				completionHandler(true)
			}
		}
	}
	
	class func signUpSecondStep(emailAddress: String, password: String, completionHandler: (Bool) -> Void) {
		let parameters: [String: String] = ["email": emailAddress, "password": "password", "os": "iOS"]
		
		Alamofire.request(.PUT, "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/auth/signup", parameters: parameters, encoding: .JSON, headers: nil) .validate() .responseJSON { response in
			
			print(response)
			
			let errorCode = response.result.value!["errorCode"] as! Int
			if errorCode != 0 {
				completionHandler(false)
			} else {
				let userData = response.result.value!["data"] as! [String: AnyObject]
				saveUserData(userData)
				
				completionHandler(true)
			}
		}
	}
	
	class func signIn(emailAddress: String, password: String, completionHandler: (Bool) -> Void) {
		let parameters: [String: String] = ["email": "alexandru.clapa@gmail.com", "password": "password", "os": "iOS"]
		
		Alamofire.request(.POST, "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/auth/signin", parameters: parameters, encoding: .JSON, headers: nil) .validate() .responseJSON { response in
			
			print(response)
			
			let errorCode = response.result.value!["errorCode"] as! Int
			if errorCode != 0 {
				completionHandler(false)
			} else {
				let userData = response.result.value!["data"] as! [String: AnyObject]
				saveUserData(userData)
				
				completionHandler(true)
			}
		}
	}
	
	class func signOut(completionHandler: (Bool) -> Void) {
		let headers = getHeaders()
		
		Alamofire.request(.POST, "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/auth/signout", parameters: nil, encoding: .JSON, headers: headers) .validate() .responseJSON() { response in
			let errorCode = response.result.value!["errorCode"] as! Int
			if errorCode != 0 {
				completionHandler(false)
			} else {
				self.clearUserData()
				completionHandler(true)
			}
		}
	}
	
	class func facebookSignIn(parameters: [String: AnyObject], completionHandler: (Bool) -> Void) {
		let urlString = "http://139.59.161.63:8080/projabox-webapp/api/rest/v1/auth/fb"		
		
		Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON, headers: nil) .validate() .responseJSON() { response in
			let errorCode = response.result.value!["errorCode"] as! Int
			print(response)
			if errorCode != 0 {
				print("facebook sign in unsuccessful")
				completionHandler(false)
			} else {
				print("facebook sign in successful")
				let userData = response.result.value!["data"] as! [String: AnyObject]
				saveUserData(userData)
				
				completionHandler(true)
			}
		}
	}
	
	private class func getHeaders() -> [String: String] {
		let userData = NSUserDefaults.standardUserDefaults().objectForKey("userData")
		let userId = userData!["userId"] as! Int
		let deviceId = userData!["deviceId"] as! Int
		let token = userData!["token"] as! String
		
		return ["Z-UserId": String(userId), "Z-DeviceId": String(deviceId), "Z-Token": token]
	}
	
	private class func saveUserData(userData: [String: AnyObject]) {
		print(userData)
		NSUserDefaults.standardUserDefaults().setObject(userData, forKey: "userData")
		NSUserDefaults.standardUserDefaults().synchronize()
	}
	
	private class func clearUserData() {
		if let appDomain = NSBundle.mainBundle().bundleIdentifier {
			NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
		}
	}
}
