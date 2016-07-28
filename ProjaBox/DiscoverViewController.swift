//
//  DiscoverViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 16/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import SwiftSpinner

import AlamofireImage
import Alamofire

class DiscoverViewController: UIViewController, YSSegmentedControlDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var tableView: UITableView?
	
	lazy var searchBar: UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 20))
	
	var results = [AnyObject]()
	
	var segmentedControl: YSSegmentedControl?
	var selectedIndex: Int = 0
	var selectedName: Int = 0
	var selectedIdToMessage = String()
	
	var blurEffectView = UIVisualEffectView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		setupSegmentedControl()
		
		searchBar.delegate = self
		
		tableView!.registerNib(UINib(nibName: "DiscoverProjectTableViewCell", bundle: nil), forCellReuseIdentifier: "discoverProjectCell")
		tableView!.registerNib(UINib(nibName: "DiscoverPeopleTableViewCell", bundle: nil), forCellReuseIdentifier: "discoverPeopleCell")
		
		let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
		blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = view.bounds
		blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
		
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
			return 288.0
		} else {
			return 232.0
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
			
			cell.followButton.tag = indexPath.row
			cell.likeButton.tag = indexPath.row
			cell.messageButton.tag = indexPath.row
			
			cell.followButton.addTarget(self, action: #selector(self.followButtonPressed(_:)), forControlEvents: .TouchUpInside)
			cell.messageButton.addTarget(self, action: #selector(self.messageButtonPressed(_:)), forControlEvents: .TouchUpInside)
			
			if let name = projectResult.name {
				let tap = UITapGestureRecognizer(target: self, action: #selector(self.nameButtonPressed(_:)))
				cell.nameLabel?.text = name
				cell.nameLabel!.tag = indexPath.row
				cell.nameLabel?.addGestureRecognizer(tap)
				cell.profileImageView.addGestureRecognizer(tap)
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
			
			if let isFollowed = projectResult.isFollowed {
				if isFollowed == true {
					cell.followButton.selected = true
				} else {
					cell.followButton.selected = true
				}
			}
			
			if ((projectResult.avatar?.isEqual(NSNull)) != nil) {
				if let url = projectResult.avatar {
					Alamofire.request(.GET, url)
						.responseImage { response in
							if let image = response.result.value {
								print("image downloaded: \(image)")
								cell.profileImageView!.image = image
							}
					}
				}
			}
			
			
			return cell
		}
		
		let cell = tableView.dequeueReusableCellWithIdentifier("discoverPeopleCell", forIndexPath: indexPath) as! DiscoverPeopleTableViewCell
		let userResult = result as! User
		
		cell.followButton.tag = indexPath.row
		cell.likeButton.tag = indexPath.row
		cell.messageButton.tag = indexPath.row
		
		cell.messageButton.addTarget(self, action: #selector(self.messageButtonPressed(_:)), forControlEvents: .TouchUpInside)
		
		cell.followButton.addTarget(self, action: #selector(self.followButtonPressed(_:)), forControlEvents: .TouchUpInside)
		
		if let name = userResult.name {
			let tap = UITapGestureRecognizer(target: self, action: #selector(self.nameButtonPressed(_:)))
			cell.nameLabel?.text = name
			cell.nameLabel!.tag = indexPath.row
			cell.nameLabel?.addGestureRecognizer(tap)
			cell.profileImageView.addGestureRecognizer(tap)
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
		
		if let position = userResult.position {
			cell.positionLabel.text = position
		}
		
		if let isFollowed = userResult.isFollowed {
			if isFollowed == true {
				cell.followButton.selected = true
			} else {
				cell.followButton.selected = true
			}
		}
		
		if let isLiked = userResult.isLikedByMe {
			if isLiked == true {
				cell.likeButton.selected = true
			} else {
				cell.likeButton.selected = true
			}
		}
		
		if ((userResult.avatar?.isEqual(NSNull)) != nil) {
			if let url = userResult.avatar {
				Alamofire.request(.GET, url)
					.responseImage { response in
						if let image = response.result.value {
							print("image downloaded: \(image)")
							cell.profileImageView!.image = image
						}
				}
			}
		}
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		cellGotSelected(indexPath.row)
	}
	
	// MARK: User Interaction
	
	func cellGotSelected(index: Int) {
		selectedName = index
		if selectedIndex == 0 {
			performSegueWithIdentifier("discoverShowProjectProfile", sender: self)
		} else {
			performSegueWithIdentifier("discoverShowProfile", sender: self)
		}
	}
	
	func messageButtonPressed(sender: UIButton) {
		let index = sender.tag
		let result = results[index]
		
		if selectedIndex == 0 {
			let projectResult = result as! Project
			let id = String(projectResult.id!)
			selectedIdToMessage = id
			performSegueWithIdentifier("discoverShowChat", sender: self)
		} else {
			let userResult = result as! User
			let id = String(userResult.id!)
			selectedIdToMessage = id
			performSegueWithIdentifier("discoverShowChat", sender: self)
		}
	}
	
	func likeButtonPressed(sender: UIButton) {
		let index = sender.tag
		let result = results[index]
		
		if selectedIndex == 0 {
			let projectResult = result as! Project
			if sender.selected == true {
				let id = String(projectResult.id!)
				ProjectHelper.unlikeProject(id, completionHandler: { (response) in
					sender.selected = false
				})
			} else {
				let id = String(projectResult.id!)
				ProjectHelper.likeProject(id, completionHandler: { (response) in
					sender.selected = true
				})
			}
		} else {
			let userResult = result as! User
			if sender.selected == true {
				let id = String(userResult.id!)
				ProfileHelper.unLikeUser(id, completionHandler: { (response) in
					sender.selected = false
				})
			} else {
				let id = String(userResult.id!)
				ProfileHelper.likeUser(id, completionHandler: { (response) in
					sender.selected = true
				})
			}
		}
	}
	
	func followButtonPressed(sender: UIButton) {
		let index = sender.tag
		let result = results[index]
		if selectedIndex == 0 {
			let projectResult = result as! Project
			if sender.selected == true {
				let id = String(projectResult.id!)
				ProjectHelper.unFollowProject(id, completionHandler: { (response) in
					sender.selected = false
				})
			} else {
				let id = String(projectResult.id!)
				ProjectHelper.followProject(id, completionHandler: { (response) in
					sender.selected = true
				})
			}
		} else {
			let userResult = result as! User
			let id = String(userResult.id!)
			if sender.selected == true {
				ProfileHelper.unFollowUser(id, completionHandler: { (response) in
					sender.selected = false
				})
			} else {
				ProfileHelper.followUser(id, completionHandler: { (response) in
					sender.selected = true
				})
			}
		}
	}
	
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
		print("selected index :\(selectedIndex)")
		if selectedIndex == 0 {
			performSegueWithIdentifier("discoverShowProjectProfile", sender: self)
		} else {
			print("name button pressed profile")
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
		} else if segue.identifier == "discoverShowChat" {
			let destination = segue.destinationViewController as! ConversationViewController
			destination.profileId = selectedIdToMessage
		}
	}
	
	// MARK: Search bar delegate
	
	func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
		searchBar.showsCancelButton = true
		
		tableView?.addSubview(blurEffectView)
	}
	
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
						self.blurEffectView.removeFromSuperview()
					} else {
						self.results.removeAll()
						self.tableView?.reloadData()
						self.blurEffectView.removeFromSuperview()
					}
				} else {
					self.results.removeAll()
					self.tableView?.reloadData()
					self.blurEffectView.removeFromSuperview()
				}
			})
		} else {
			SearchHelper.searchForUsers(queryString!, completionHandler: { (response, results) in
				SwiftSpinner.hide()
				if response == true {
					if let notNilResults = results {
						self.results = notNilResults
						self.tableView?.reloadData()
						self.blurEffectView.removeFromSuperview()
					} else {
						self.results.removeAll()
						self.tableView?.reloadData()
						self.blurEffectView.removeFromSuperview()
					}
				} else {
					self.results.removeAll()
					self.tableView?.reloadData()
					self.blurEffectView.removeFromSuperview()
				}
			})
		}
	}
	
	func searchBarCancelButtonClicked(searchBar: UISearchBar) {
		searchBar.showsCancelButton = false
		searchBar.resignFirstResponder()
		blurEffectView.removeFromSuperview()
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
