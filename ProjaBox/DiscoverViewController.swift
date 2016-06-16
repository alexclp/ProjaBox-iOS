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
		setupSegmentedControl()
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
	
	func setupSegmentedControl() {
		let segmented = YSSegmentedControl(
			frame: CGRect(
				x: 0,
				y: 0,
				width: view.frame.size.width,
				height: 44),
			titles: [
				"Projects",
				"People",
			],
			action: {
				control, index in
				print ("segmented did pressed \(index)")
		})
//		segmented.delegate = self
		segmented.appearance.selectedTextColor = UIColor(red: 237/256, green: 84/256, blue: 84/256, alpha: 1)
		segmented.appearance.bottomLineColor = UIColor(red: 237/256, green: 84/256, blue: 84/256, alpha: 1)
		segmented.appearance.selectorColor = UIColor(red: 237/256, green: 84/256, blue: 84/256, alpha: 1)
		
		view.addSubview(segmented)
	}
}
