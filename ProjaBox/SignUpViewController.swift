//
//  SignUpViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 20/03/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationController?.navigationBar.hidden = true
		self.view.layer.contents = UIImage(named:"background-proja.png")!.CGImage
	}
	
}
