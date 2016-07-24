//
//  ViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 16/03/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import Social

import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
	let facebookPermissions = ["public_profile", "email", "user_birthday", "user_location", "user_about_me", "user_education_history", "user_work_history"]
	
	@IBOutlet weak var facebookButton: FBSDKLoginButton?
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	lazy var fbLoginManager: FBSDKLoginManager = {
		return FBSDKLoginManager()
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		facebookButton?.delegate = self
		
		self.navigationController?.navigationBar.hidden = true
		self.view.layer.contents = UIImage(named:"sign-in-background.png")!.CGImage
	}
	
	//	MARK: Facebook Login Delegate + Fetching Data
	
	func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
		print("Facebook login")
		if ((error) != nil) {
			// Process error
			print("Error: \(error.description)")
		} else if result.isCancelled {
			// Handle cancellations
			print("Cancelled")
		} else {
			// Navigate to other view
			print("Success")
			fetchFacebookData()
		}
	}
	
	func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
		print("User Logged Out")
	}
	
	func fetchFacebookData() {
		let parameters: [String : String] = ["fields": "id, name, birthday, picture, location, gender, email, education, work"]
		FBSDKGraphRequest.init(graphPath: "me", parameters: parameters) .startWithCompletionHandler { (connection, result, error) in
			print(result)
		}
	}
}
