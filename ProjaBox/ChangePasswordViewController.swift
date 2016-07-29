//
//  ChangePasswordViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 29/07/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

	@IBOutlet weak var passwordTextField: UITextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		// Do any additional setup after loading the view.
		
		self.view.layer.contents = UIImage(named:"background-proja.png")!.CGImage
	}
	
	@IBAction func submitButtonPressed(sender: UIButton) {
		if passwordTextField.text != "" {
			ProfileHelper.changePassword(passwordTextField.text!, completionHandler: { (response) in
				if response == true {
					self.dismissViewControllerAnimated(true, completion: nil)
				}
			})
		}
	}
}
