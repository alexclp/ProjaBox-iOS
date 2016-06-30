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
	
	private class func saveUserData(userData: [String: AnyObject]) {
		print(userData)
		NSUserDefaults.standardUserDefaults().setObject(userData, forKey: "userData")
	}
}
