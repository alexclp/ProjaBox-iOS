//
//  ViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 16/03/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

import FBSDKLoginKit
import FBSDKCoreKit

import LinkedinSwift

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
	
	let facebookPermissions = ["public_profile", "email", "user_birthday", "user_location"]
	let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "77ob2fnaq59qlq", clientSecret: "oBjj94qBmnthEg4H", state: "DCEeFWf45A53sdfKef424", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "http://alexandruclapa.com"))
	
	@IBOutlet weak var facebookButton: FBSDKLoginButton?
	
	lazy var fbLoginManager: FBSDKLoginManager = {
		return FBSDKLoginManager()
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
//	MARK: LinkedIn Stuff
	
	@IBAction func linkedinLogin() {
		linkedinHelper.authorizeSuccess({ (lsToken) -> Void in
			//Login success lsToken

			print("Success")
			
			}, error: { (error) -> Void in
				//Encounter error: error.localizedDescription
			}, cancel: { () -> Void in
				//User Cancelled!
		})
	}
	

//	MARK: Facebook Login Delegate + Fetching Data
	
	func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
		if ((error) != nil) {
			// Process error
		}
		else if result.isCancelled {
			// Handle cancellations
		}
		else {
			// Navigate to other view
			fetchData()
		}
	}
	
	func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
		print("User Logged Out")
	}
	
	func fetchData() {
		let parameters: [String : String] = ["fields": "id, name, birthday, picture, location"]
		FBSDKGraphRequest.init(graphPath: "me", parameters: parameters) .startWithCompletionHandler { (connection, result, error) in
			print(result)
		}
	}

}

