//
//  SignUpPasswordViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 30/05/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class SignUpPasswordViewController: UIViewController {

	@IBOutlet weak var passwordTextField: UITextField?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		self.navigationController?.navigationBar.hidden = true
		self.view.layer.contents = UIImage(named:"background-proja.png")!.CGImage
    }

}
