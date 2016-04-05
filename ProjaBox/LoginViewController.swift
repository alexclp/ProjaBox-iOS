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

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

	let facebookPermissions = ["public_profile", "email", "user_birthday", "user_location"]
	var facebookButton: FBSDKLoginButton?
	
	lazy var fbLoginManager: FBSDKLoginManager = {
		return FBSDKLoginManager()
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupFacebookButton()
	}
	
	func setupFacebookButton() {
		facebookButton = FBSDKLoginButton()
		
		facebookButton?.frame = CGRectMake(self.view.frame.width / 2 - 90, self.view.frame.height/2 + self.view.frame.height/4, 180, 40)
		facebookButton?.readPermissions = facebookPermissions
		facebookButton?.delegate = self
		
		self.view.addSubview(facebookButton!)
	}
	
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

