//
//  SignUpPasswordViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 30/05/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class SignUpPasswordViewController: UIViewController {
	
	var email = ""

	@IBOutlet weak var passwordTextField: UITextField?
	
	// TODO: SCROLL VIEW WHEN KEYBOARD APPEARS
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		self.navigationController?.navigationBar.hidden = true
		self.view.layer.contents = UIImage(named:"background-proja.png")!.CGImage
    }
	
	@IBAction func signUpPressed(sender: UIButton) {
		let password = passwordTextField?.text
		
		SignInHelper.signUpSecondStep(email, password: password!) { (response) in
			if response == true {
				self.performSegueWithIdentifier("showPostsSegue", sender: self)
			} else {
				let alert = UIAlertController(title: "Alert", message: "There was an error while registering. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
				alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
				self.presentViewController(alert, animated: true, completion: nil)
			}
		}
	}

}
