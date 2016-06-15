//
//  DiscoverViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 16/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
	
	lazy var searchBar: UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 20))

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		setupBarButtons()
	}
	
	func setupBarButtons() {
		self.tabBarController?.navigationItem.leftBarButtonItem = nil
		self.tabBarController?.navigationItem.rightBarButtonItem = nil
		
		searchBar.placeholder = "search..."
		self.tabBarController!.navigationItem.titleView = searchBar
	}
}
