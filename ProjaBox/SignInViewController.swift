//
//  SignInViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 02/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
	
	@IBOutlet weak var emailTextField: UITextField?
	@IBOutlet weak var passwordTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		self.navigationController?.navigationBar.hidden = true
		self.view.layer.contents = UIImage(named:"sign-in-background.png")!.CGImage
    }
	
	@IBAction func singInPressed(sender: UIButton) {
		SignInHelper.signIn((emailTextField?.text)!, password: (passwordTextField?.text)!) { (response) in
			if response == true {
				self.performSegueWithIdentifier("showFeedSegue", sender: self)
			} 
		}
	}
}
