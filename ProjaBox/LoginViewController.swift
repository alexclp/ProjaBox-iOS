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
		let parameters: [String : String] = ["fields": "name, birthday, picture, location, gender, email"]
		FBSDKGraphRequest.init(graphPath: "me", parameters: parameters) .startWithCompletionHandler { (connection, result, error) in
			print(result)
			var signInParameters = [String: AnyObject]()
			if let birthday = result["birthday"] as? String {
				let dateFormatter = NSDateFormatter()
				dateFormatter.dateFormat = "dd/MM/yyyy"
				let date = dateFormatter.dateFromString(birthday)
				dateFormatter.dateFormat = "yyyy-MM-dd"
				let dateString = dateFormatter.stringFromDate(date!)
				signInParameters["dob"] = dateString
			}
			if let email = result["email"] as? String {
				signInParameters["email"] = email
			}
			if let socialId = result["id"] as? String {
				signInParameters["socialId"] = socialId
			}
			if let name = result["name"] as? String {
				signInParameters["name"] = name
			}
			if let avatarData = result["picture"] {
				signInParameters["avatar"] = (avatarData["data"]!["url"] as! String)
			}
			if let dob = result["dob"] as? String {
				signInParameters["dob"] = dob
			}
			if let gender = result["gender"] as? String {
				if gender == "male" {
					signInParameters["sex"] = "M"
				} else if gender == "female" {
					signInParameters["sex"] = "F"
				}
			}
			signInParameters["os"] = "iOS"
			print(signInParameters)
			SignInHelper.facebookSignIn(signInParameters, completionHandler: { (response) in
				if response == true {
					self.performSegueWithIdentifier("showFeed", sender: self)
				}
			})
		}
	}
}
