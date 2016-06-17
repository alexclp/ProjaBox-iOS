//
//  DiscoverViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 16/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import SwiftSpinner

class DiscoverViewController: UIViewController, YSSegmentedControlDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var tableView: UITableView?
	
	lazy var searchBar: UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 20))
	
	var results = [AnyObject]()
	
	var segmentedControl: YSSegmentedControl?
	var selectedIndex: Int = 0
	var selectedName: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		setupSegmentedControl()
		
		searchBar.delegate = self
		
		tableView!.registerNib(UINib(nibName: "DiscoverProjectTableViewCell", bundle: nil), forCellReuseIdentifier: "discoverProjectCell")
		tableView!.registerNib(UINib(nibName: "DiscoverPeopleTableViewCell", bundle: nil), forCellReuseIdentifier: "discoverPeopleCell")
		
		loadLastAddedResults()
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
		
//		let filtersButton = UIBarButtonItem(image: UIImage(named: "filter.png")!, style: .Plain, target: self, action: #selector(self.showFilters(_:)))
//		self.tabBarController?.navigationItem.rightBarButtonItem = filtersButton
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
	
	// MARK: Table View Methods
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if results[0] is Project {
			return 359.0
		} else {
			return 274.0
		}
 	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return results.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let result = results[indexPath.row]
		
		if result is Project {
			let cell = tableView.dequeueReusableCellWithIdentifier("discoverProjectCell", forIndexPath: indexPath) as! DiscoverProjectTableViewCell
			let projectResult = result as! Project
			
			if let name = projectResult.name {
				let tap = UITapGestureRecognizer(target: self, action: #selector(self.nameButtonPressed(_:)))
				cell.nameLabel?.text = name
				cell.nameLabel!.tag = indexPath.row
				cell.nameLabel?.addGestureRecognizer(tap)
			}
			
			if let description = projectResult.desc {
				cell.descriptionLabel.text = description
			}
			
			if let location = projectResult.location {
				cell.locationLabel.text = location
			}
			
			if let isLikedByMe = projectResult.isLikedByMe {
				if isLikedByMe == true {
					cell.likeButton.selected = true
				}
			}
			
			if let type = projectResult.type {
				cell.typeLabel.text = type
			}
			
			if let jobs = projectResult.jobs {
				cell.jobsTagListView.removeAllTags()
				for job in jobs {
					cell.jobsTagListView.addTag(job)
				}
			}
			
			if let likers = projectResult.likers {
				cell.likesLabel.text = String(likers.count)
			}
			
			return cell
		}
		
		let cell = tableView.dequeueReusableCellWithIdentifier("discoverPeopleCell", forIndexPath: indexPath) as! DiscoverPeopleTableViewCell
		let userResult = result as! User
		
		if let name = userResult.name {
			cell.nameLabel.text = name
		}
		
		if let location = userResult.location {
			cell.locationLabel.text = location
		}
		
		if let likers = userResult.likers {
			cell.likesLabel.text = String(likers.count)
		}
		
		if let about = userResult.about {
			cell.descriptionLabel.text = about
		}
		
		if let status = userResult.status {
			cell.statusLabel.text = status
		}
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
	// MARK: User Interaction
	
	func segmentedControlDidPressedItemAtIndex(segmentedControl: YSSegmentedControl, index: Int) {
		selectedIndex = index
		loadLastAddedResults()
	}
	
	func showFilters(sender: UIBarButtonItem) {
		if selectedIndex == 0 {
			performSegueWithIdentifier("showProjectFiltersSegue", sender: self)
		} else {
			performSegueWithIdentifier("showPeopleFilterSegue", sender: self)
		}
	}
	
	func nameButtonPressed(sender: UIGestureRecognizer) {
		selectedName = (sender.view?.tag)!
		if selectedIndex == 0 {
			performSegueWithIdentifier("discoverShowProjectProfile", sender: self)
		} else {
			performSegueWithIdentifier("discoverShowProfile", sender: self)
		}
		
	}
	
	// MARK: Segue
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "discoverShowProfile" {
			let destination = segue.destinationViewController as! PersonProfileViewController
			let userResult = results[selectedName] as! User
			let id = String(userResult.id!)
			destination.userId = id
		} else if segue.identifier == "discoverShowProjectProfile" {
			let destination = segue.destinationViewController as! ProjectViewOnlyViewController
			let projectResult = results[selectedName] as! Project
			let id = String(projectResult.id!)
			destination.projectId = id
		}
	}
	
	// MARK: Search bar delegate
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		let queryString = searchBar.text
		SwiftSpinner.show("Searching...")
		
		if selectedIndex == 0 {
			SwiftSpinner.hide()
			SearchHelper.searchForProjects(queryString!, completionHandler: { (response, results) in
				if response == true {
					if let notNilResults = results {
						self.results = notNilResults
						self.tableView?.reloadData()
					} else {
						self.results.removeAll()
						self.tableView?.reloadData()
					}
				} else {
					
				}
			})
		} else {
			SearchHelper.searchForUsers(queryString!, completionHandler: { (response, results) in
				SwiftSpinner.hide()
				if response == true {
					if let notNilResults = results {
						self.results = notNilResults
						self.tableView?.reloadData()
					} else {
						self.results.removeAll()
						self.tableView?.reloadData()
					}
				} else {
					
				}
			})
		}
	}
	
	// MARK: Loading last added
	
	func loadLastAddedResults() {
		SwiftSpinner.show("Loading data")
		if selectedIndex == 0 {
			SwiftSpinner.hide()
			SearchHelper.getLatestProjects({ (response, results) in
				if let notNilResults = results {
					self.results = notNilResults
					self.tableView?.reloadData()
				} else {
					self.results.removeAll()
					self.tableView?.reloadData()
				}
			})
		} else {
			SearchHelper.getLatestUsers({ (response, results) in
				SwiftSpinner.hide()
				if response == true {
					if let notNilResults = results {
						self.results = notNilResults
						self.tableView?.reloadData()
					} else {
						self.results.removeAll()
						self.tableView?.reloadData()
					}
				}
			})
		}
	}
}
