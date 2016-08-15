//
//  SignUpViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 20/03/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
	
	@IBOutlet weak var emailTextField: UITextField?
	
	// TODO: SCROLL VIEW WHEN KEYBOARD APPEARS
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationController?.navigationBar.hidden = true
		self.view.layer.contents = UIImage(named:"background-proja.png")!.CGImage
	}
	
	@IBAction func signUpPressed(sender: UIButton) {
		let emailAddress = emailTextField?.text
		
		if isValidEmail(emailAddress!) {
			SignInHelper.signUpFirstStep((emailTextField?.text)!, completionHandler: { (response) in
				if response == true {
					self.performSegueWithIdentifier("showPasswordSegue", sender: self)
				} else {
					let alert = UIAlertController(title: "Alert", message: "There was an error while registering. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
					alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
					self.presentViewController(alert, animated: true, completion: nil)
				}
			})
		} else {
			let alert = UIAlertController(title: "Alert", message: "Enter a valid email address!", preferredStyle: UIAlertControllerStyle.Alert)
			alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
			presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showPasswordSegue" {
			let destinationVc = segue.destinationViewController as! SignUpPasswordViewController
			destinationVc.email = (emailTextField?.text)!
			
		}
	}
	
	func isValidEmail(testStr:String) -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		
		let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailTest.evaluateWithObject(testStr)
	}
	
	
}
