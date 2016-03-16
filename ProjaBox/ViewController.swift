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

	let facebookReadPermissions = ["public_profile", "email", "user_friends"]
	let facebookButton = FBSDKLoginButton()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		facebookButton.center = self.view.center
		self.view.addSubview(facebookButton)
		
	}

}

