//
//  InitialViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 03/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		self.navigationController?.navigationBar.hidden = true
		
		if NSUserDefaults.standardUserDefaults().objectForKey("userData") == nil {
			performSegueWithIdentifier("showLoginSegue", sender: self)
		} else {
			performSegueWithIdentifier("showFeedSegue", sender: self)
		}
	}
}
