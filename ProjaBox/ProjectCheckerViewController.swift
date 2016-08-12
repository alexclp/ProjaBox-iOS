//
//  ProjectCheckerViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 09/08/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class ProjectCheckerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		setupBarButtons()
		if NSUserDefaults.standardUserDefaults().objectForKey("projectId") != nil {
			// has project
			performSegueWithIdentifier("showProjectSegue", sender: self)
		} else {
			// doesn't have project
			performSegueWithIdentifier("showProjectCreaterSegue", sender: self)
		}
    }
	
	func setupBarButtons() {
		self.tabBarController?.navigationItem.titleView = nil
		self.tabBarController?.navigationItem.rightBarButtonItem = nil
		self.tabBarController?.navigationItem.leftBarButtonItem = nil
	}
}
