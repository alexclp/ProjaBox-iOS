//
//  CreateProjectViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 09/08/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class CreateProjectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		self.view.layer.contents = UIImage(named:"background_project.png")!.CGImage
		setupBarButtons()
    }
	
	func setupBarButtons() {
		self.tabBarController?.navigationItem.titleView = nil
		self.tabBarController?.navigationItem.rightBarButtonItem = nil
		self.tabBarController?.navigationItem.leftBarButtonItem = nil
	}
}
