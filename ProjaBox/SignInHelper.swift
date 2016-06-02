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
			
			print(response.result.value!["errorCode"])
			
			let errorCode = response.result.value!["errorCode"] as! Int
			if errorCode != 0 {
				completionHandler(false)
			} else {
				completionHandler(true)
			}
		}
	}
}
