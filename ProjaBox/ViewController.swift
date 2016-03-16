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

class ViewController: UIViewController {

	let facebookPermissions = ["public_profile", "email", "user_friends"]
	var facebookButton: FBSDKLoginButton?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		facebookButton = FBSDKLoginButton()
		facebookButton!.center = self.view.center
		
		let loginMethodSelector = Selector("facebookButtonClicked")
		
		facebookButton?.addTarget(self, action: loginMethodSelector, forControlEvents: .TouchUpInside)
		
		self.view.addSubview(facebookButton!)
		
	}
	
	func facebookButtonClicked() {
		let loginManager = FBSDKLoginManager()
		loginManager.logInWithReadPermissions(facebookPermissions, fromViewController: self) { (result, error) -> Void in
			if ((error) != nil) {
				print("Process error \(error.description)")
			} else if (result.isCancelled) {
				print("Cancelled")
			} else {
				print("Logged in")
			}
		}
	}

}

