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
