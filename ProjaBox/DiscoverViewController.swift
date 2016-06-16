//
//  DiscoverViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 16/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, YSSegmentedControlDelegate, UISearchBarDelegate {
	
	lazy var searchBar: UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 20))
	
	var segmentedControl: YSSegmentedControl?
	var selectedIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		setupSegmentedControl()
		
		searchBar.delegate = self
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		setupBarButtons()
	}
	
	// MARK: UI Setup
	
	func setupBarButtons() {
		self.tabBarController?.navigationItem.leftBarButtonItem = nil
		self.tabBarController?.navigationItem.rightBarButtonItem = nil
		
		searchBar.placeholder = "search..."
		self.tabBarController!.navigationItem.titleView = searchBar
		
		let filtersButton = UIBarButtonItem(title: "Filters", style: .Plain, target: self, action: #selector(self.showFilters(_:)))
		self.tabBarController?.navigationItem.rightBarButtonItem = filtersButton
	}
	
	func setupSegmentedControl() {
		segmentedControl = YSSegmentedControl(
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
		})
		segmentedControl!.delegate = self
		segmentedControl!.appearance.selectedTextColor = UIColor(red: 237/256, green: 84/256, blue: 84/256, alpha: 1)
		segmentedControl!.appearance.bottomLineColor = UIColor(red: 237/256, green: 84/256, blue: 84/256, alpha: 1)
		segmentedControl!.appearance.selectorColor = UIColor(red: 237/256, green: 84/256, blue: 84/256, alpha: 1)
		
		view.addSubview(segmentedControl!)
	}
	
	// MARK: User Interaction
	
	func segmentedControlDidPressedItemAtIndex(segmentedControl: YSSegmentedControl, index: Int) {
		selectedIndex = index
	}
	
	func showFilters(sender: UIBarButtonItem) {
		if selectedIndex == 0 {
			performSegueWithIdentifier("showProjectFiltersSegue", sender: self)
		} else {
			performSegueWithIdentifier("showPeopleFilterSegue", sender: self)
		}
	}
	
	// MARK: Search bar delegate
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//		let queryString = searchBar.text
	}
}
