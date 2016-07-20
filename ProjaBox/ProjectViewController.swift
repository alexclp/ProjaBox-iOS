//
//  ProjectViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 27/03/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import KCFloatingActionButton

import Alamofire
import AlamofireImage

class ProjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BioDataDelegate, GoalsInputDelegate, ExperienceInputDelegate, InterestsInputDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
	
	@IBOutlet weak var tableView: UITableView?
	@IBOutlet weak var floatingButton = KCFloatingActionButton()
	
	let imagePicker = UIImagePickerController()
	
	var headerData = [String: String]()
	var teamData = [[String: AnyObject]]()
	var postsData = [ProjectPost]()
	var goals = String()
	var jobs = [String]()
	
	var fullProjectData = [String: AnyObject]()
	var projectData = [String: AnyObject]()

	let profileParameters = ["type", "name", "goals", "avatar", "description", "location", "video", "links", "jobs"]

	var collectionViewSourceArray: [UIColor] = [UIColor.greenColor(), UIColor.blueColor(), UIColor.blackColor()]
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		self.tabBarController?.navigationItem.leftBarButtonItem = nil
		self.tabBarController?.navigationItem.titleView = nil
		self.tabBarController?.navigationItem.rightBarButtonItem = nil
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		tableView!.registerNib(UINib(nibName: "EducationExperienceTableViewCell", bundle: nil), forCellReuseIdentifier: "educationExperienceCell")
		tableView!.registerNib(UINib(nibName: "ProfileHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "profileHeaderCell")
		tableView!.registerNib(UINib(nibName: "InterestsTableViewCell", bundle: nil), forCellReuseIdentifier: "interestsCell")
		tableView!.registerNib(UINib(nibName: "FeedCardTableViewCell", bundle: nil), forCellReuseIdentifier: "cardCell")
		tableView!.registerNib(UINib(nibName: "GoalsTableViewCell", bundle: nil), forCellReuseIdentifier: "goalsCell")
		tableView!.registerNib(UINib(nibName: "PhotosTableViewCell", bundle: nil), forCellReuseIdentifier: "photosCell")
		tableView!.registerNib(UINib(nibName: "PhotoCardTableViewCell", bundle: nil), forCellReuseIdentifier: "photoCardCell")
		tableView!.registerClass(DHCollectionTableViewCell.self, forCellReuseIdentifier: "TableViewCell")
		
		imagePicker.delegate = self
		imagePicker.navigationBar.translucent = false
		imagePicker.navigationBar.barTintColor = UIColor(red: 237/255, green: 84/255, blue: 84/255, alpha: 1.0) // Background color
		imagePicker.navigationBar.tintColor = .whiteColor() // Cancel button ~ any UITabBarButton items
		imagePicker.navigationBar.titleTextAttributes = [
			NSForegroundColorAttributeName : UIColor.whiteColor()
		] // Title color

		
		getProfile()
		setupPostButton()
	}
	
	func setupBarButtons() {
		
	}
	
	func setupPostButton() {
		floatingButton!.addItem("Make a new text post", icon: UIImage(named: "share-float.png")!, handler: { item in
			self.performSegueWithIdentifier("showCreatePostSegue", sender: self)
			self.floatingButton?.close()
		})
		floatingButton!.addItem("Make a new image post", icon: UIImage(named: "share-float.png")!, handler: { item in
			self.imagePicker.allowsEditing = false
			self.imagePicker.sourceType = .PhotoLibrary
			
			self.presentViewController(self.imagePicker, animated: true, completion: nil)
			self.floatingButton?.close()
		})
	}
	
	func getProfile() {
		if NSUserDefaults.standardUserDefaults().objectForKey("projectId") != nil {
			let id = String(NSUserDefaults.standardUserDefaults().objectForKey("projectId") as! Int)
			ProjectHelper.getFullProjectProfile(id, completionHandler: { (response, data) in
				
				if response == true {
					print(data)
					self.fullProjectData = data!
					self.getLatestPosts()
					if let name = data!["name"] {
						self.projectData["name"] = name as? String
						self.headerData["name"] = name as? String
					}
					
					if let description = data!["description"] {
						self.projectData["description"] = description as? String
						self.headerData["description"] = description as? String
					}
					
					if let location = data!["location"] {
						self.projectData["location"] = location as? String
						self.headerData["location"] = location as? String
					}
					
					if let goals = data!["goals"] as? String {
						self.projectData["goals"] = goals
						self.goals = goals
					}
					
					if let type = data!["type"] {
						self.projectData["type"] = type as? String
						self.headerData["type"] = type as? String
					}
					
					if let team = data!["team"] as? [[String: AnyObject]] {
						self.projectData["team"] = team
						self.teamData = team
					}
					
					if let jobs = data!["jobs"] as? [String] {
						self.projectData["jobs"] = jobs
						self.jobs = jobs
					}
					self.tableView?.reloadData()
				}
			})
		}
	}
	
	func getLatestPosts() {
		ProjectHelper.getProjectsLatestPosts(String(NSUserDefaults.standardUserDefaults().objectForKey("projectId") as! Int)) { (response, posts) in
			if response == true {
				self.postsData = posts!
				self.tableView?.reloadData()
			}
		}
	}
	
	func getTeammates() {
		ProjectHelper.getProjectTeammates(String(NSUserDefaults.standardUserDefaults().objectForKey("projectId") as! Int)) { (response, mates) in
			if response == true {
				self.teamData = mates!
				self.tableView?.reloadData()
			}
		}
	}
	
	// MARK: UIImagePicker Delegate
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		dismissViewControllerAnimated(true, completion: nil)
		let strBase64 = CompressedImage.encodeImageLowetQuality(image)
		ProjectHelper.createPost(String(fullProjectData["id"] as! Int), "Post", "Image Post", strBase64, nil) { (response) in
			if response == true {
				self.getLatestPosts()
			}
		}
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	// MARK: UITableView Methods
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		let section = indexPath.section
		if section == 0 {
			return 293.0
		} else if section == 1 {
			return 115.0
		} else if section == 2 {
			return 115.0
		} else if section == 3 {
			return 115.0
		} else if section == 4 {
			return 115.0
		} else if section == 5 {
			return 115.0
		} else if section == 6 {
			if postsData[indexPath.row].image != nil {
				return 308.0
			}
			return 221.0
		}
		
		return 0
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 2 {
			return "Goals"
		} else if section == 3 {
			return "Photos"
		} else if section == 4 {
			return "Team"
		} else if section == 5 {
			return "Jobs"
		} else if section == 6 {
			return "Posts"
		}
		return ""
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 7
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			// HEADER
			return 1
		} else if section == 1 {
			// VIDEO
			return 0
		} else if section == 2 {
			// GOALS
			return 1
		} else if section == 3 {
			// PHOTOS
			return 1
		} else if section == 4 {
			// TEAM
			return teamData.count + 1
		} else if section == 5 {
			// JOBS
			return 1
		} else if section == 6 {
			// POSTS
			return postsData.count
		}
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let section = indexPath.section
		
		if section == 0 {
			// HEADER
			let cell = tableView.dequeueReusableCellWithIdentifier("profileHeaderCell", forIndexPath: indexPath) as! ProfileHeaderTableViewCell
			cell.editButton?.addTarget(self, action: #selector(self.editHeaderButtonPressed(_:)), forControlEvents: .TouchUpInside)
			cell.statusLabel?.hidden = true
			cell.tagsLabel?.hidden = true
			
			if let location = headerData["location"] {
				cell.locationLabel?.text = location
			}
			
			if let name = headerData["name"] {
				cell.nameLabel?.text = name
			}
			
			if let type = headerData["type"] {
				cell.positionLabel?.hidden = true
				cell.projectTypeLabel?.hidden = false
				cell.projectTypeLabel?.text = type
			}
			
			if let desc = headerData["description"] {
				cell.descriptionLabel?.text = desc
			}
			
			if let url = fullProjectData["avatar"] {
				let urlString = url as? String
				if urlString != nil {
					Alamofire.request(.GET, (url as! String))
						.responseImage { response in
							if let image = response.result.value {
								print("image downloaded: \(image)")
								cell.profileImageView!.image = image
							}
					}
				}
			}
			
			return cell
		} else if section == 1 {
			// TODO: Video section
		} else if section == 2 {
			// GOALS
			let cell = tableView.dequeueReusableCellWithIdentifier("goalsCell", forIndexPath: indexPath) as! GoalsTableViewCell
			cell.editButton?.addTarget(self, action: #selector(self.editGoalsButtonPressed(_:)), forControlEvents: .TouchUpInside)
			cell.goalsTextView?.text = goals
			
			return cell
		} else if section == 3 {
			// PHOTOS
			let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as! DHCollectionTableViewCell
			
			return cell
		} else if section == 4 {
			// TEAM SECTION
			let cell = tableView.dequeueReusableCellWithIdentifier("educationExperienceCell", forIndexPath: indexPath) as! EducationExperienceTableViewCell
			cell.periodLabel?.text = ""
			if indexPath.row == teamData.count || teamData.count == 0 {
				cell.companyNameLabel?.text = "Add a new team member"
				
			} else {
				let currentTeamMember = teamData[indexPath.row]
				
				if let name = currentTeamMember["name"] {
					cell.companyNameLabel?.text = name as? String
				}
				
				if let position = currentTeamMember["position"] {
					cell.positionLabel?.text = position as? String
				}
				
				if let imageURL = currentTeamMember["avatar"] {
					Alamofire.request(.GET, (imageURL as! String))
						.responseImage { response in
							if let image = response.result.value {
								print("image downloaded: \(image)")
								cell.profileImageView!.image = image
							}
					}
				}
			}
			
			return cell
		} else if section == 5 {
			// JOB SECTION
			let cell = tableView.dequeueReusableCellWithIdentifier("interestsCell", forIndexPath: indexPath) as! InterestsTableViewCell
			cell.editButton?.addTarget(self, action: #selector(self.editJobsButtonPressed(_:)), forControlEvents: .TouchUpInside)
			cell.tagListView?.removeAllTags()
			
			cell.tagListView?.removeAllTags()
			
			for job in jobs {
				cell.tagListView?.addTag(job)
			}
			
			return cell
		}
		
		// POST SECTION
		let currentPost = postsData[indexPath.row]
		
		if let imageURL = currentPost.image {
			let cell = tableView.dequeueReusableCellWithIdentifier("photoCardCell", forIndexPath: indexPath) as! PhotoCardTableViewCell
			cell.authorLocationLabel?.text = ""
			cell.locationImageView?.hidden = true
			cell.authorDetailsLabel?.text = ""
			
			Alamofire.request(.GET, imageURL)
				.responseImage { response in
					if let image = response.result.value {
						print("image downloaded: \(image)")
						cell.postImage!.image = image
					}
			}
			
			if let likers = currentPost.likers {
				cell.likesLabel?.text = String(likers.count)
			}
			
			if let time = currentPost.createdTimestamp {
				cell.currentTimeLabel?.text = NewsFeedHelper.getTimeFromTimestamp(time)
			}
			
			if let name = fullProjectData["name"] {
				cell.authorLabel?.text = name as? String
			}
			
			if let position = fullProjectData["type"] {
				cell.authorDetailsLabel?.text = position as? String
			}
			
			if let location = fullProjectData["location"] {
				cell.authorLocationLabel?.text = location as? String
			}
			
			if let url = fullProjectData["avatar"] {
				let urlString = url as? String
				if urlString != nil {
					Alamofire.request(.GET, (url as! String))
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
		
		let cell = tableView.dequeueReusableCellWithIdentifier("cardCell", forIndexPath: indexPath) as! FeedCardTableViewCell
		
		cell.postLabel?.text = currentPost.content
		cell.currentTimeLabel?.text = NewsFeedHelper.getTimeFromTimestamp(currentPost.createdTimestamp!)
		if let likers = currentPost.likers {
			cell.likesLabel?.text = String(likers.count)
		}
		if currentPost.isLikedByMe == true {
			cell.likeButton!.selected = true
		}
		if let name = currentPost.projectName {
			cell.authorLabel?.text = name
		}
		if let url = currentPost.ownerAvatar {
			Alamofire.request(.GET, url)
				.responseImage { response in
					if let image = response.result.value {
						print("image downloaded: \(image)")
						cell.profileImageView!.image = image
					}
			}
		}
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		if indexPath.section == 4 {
			performSegueWithIdentifier("editTeamSegue", sender: self)
		}
	}
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 3 {
			let collectionCell = cell as! DHCollectionTableViewCell
			collectionCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, index: indexPath.row)
			
//			let index = collectionCell.collectionView.tag
//			let value = contentOffsetDictionary[index]
//			let horizontalOffset = CGFloat(value != nil ? value!.floatValue : 0)
//			collectionCell.collectionView.setContentOffset(CGPointMake(horizontalOffset, 0), animated: false)
		}
	}
	
	// MARK: Collection View Methods
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return collectionViewSourceArray.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath)
		
		cell.backgroundColor = collectionViewSourceArray[indexPath.item]
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let itemColor: UIColor = collectionViewSourceArray[indexPath.item]
		
		let alert = UIAlertController(title: "第\(collectionView.tag)行", message: "第\(indexPath.item)个元素", preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
		let v: UIView = UIView(frame: CGRectMake(10, 20, 50, 50))
		v.backgroundColor = itemColor
		alert.view.addSubview(v)
		presentViewController(alert, animated: true, completion: nil)
	}
//	
//	func scrollViewDidScroll(scrollView: UIScrollView) {
//		if !(scrollView is UICollectionView) {
//			return
//		}
//		let horizontalOffset = scrollView.contentOffset.x
//		let collectionView = scrollView as! UICollectionView
//		contentOffsetDictionary[collectionView.tag] = horizontalOffset
//	}
	
	// MARK: User Interaction
	
	func editGoalsButtonPressed(sender: UIButton) {
		performSegueWithIdentifier("editProjectGoalsSegue", sender: self)
	}
	
	func editHeaderButtonPressed(sender: UIButton) {
		performSegueWithIdentifier("editProjectHeaderSegue", sender: self)
	}
	
	func editJobsButtonPressed(sender: UIButton) {
		performSegueWithIdentifier("editJobsSegue", sender: self)
	}
	
	// MARK: Segue config
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "editProjectHeaderSegue" {
			let destination = segue.destinationViewController as! EditAboutProjectViewController
			destination.delegate = self
			destination.data = headerData
		} else if segue.identifier == "editProjectGoalsSegue" {
			let destination = segue.destinationViewController as! EditGoalsViewController
			destination.delegate = self
			destination.goals = goals
		} else if segue.identifier == "editTeamSegue" {
			let destination = segue.destinationViewController as! EditTeamViewController
			destination.delegate = self
		} else if segue.identifier == "editJobsSegue" {
			let destination = segue.destinationViewController as! EditJobsFormViewController
			destination.delegate = self
			destination.jobsList = jobs
		} else if segue.identifier == "showCreatePostSegue" {
			let navcon = segue.destinationViewController as! UINavigationController
			let destination = navcon.viewControllers[0] as! CreatingPostViewController
			destination.projectPost = true
			let id = String(NSUserDefaults.standardUserDefaults().objectForKey("projectId") as! Int)
			destination.projectId = id
		}
	}
	
	// MARK: Forms Delegates Methods
	
	func userDidFinishCompletingData(bioData: [String : AnyObject]) {
		headerData["name"] = bioData["name"] as? String
		headerData["description"] = bioData["description"] as? String
		headerData["type"] = bioData["type"] as? String
		headerData["location"] = bioData["location"] as? String
		headerData["avatar"] = bioData["avatar"] as? String
		
		projectData["name"] = headerData["name"]
		projectData["description"] = headerData["description"]
		projectData["type"] = headerData["type"]
		projectData["location"] = headerData["location"]
		projectData["avatar"] = headerData["avatar"]
		
		//		tableView?.reloadData()
		updateProfile()
	}
	
	func userFinishedEditingGoals(goals: String) {
		self.goals = goals
		projectData["goals"] = goals
		tableView?.reloadData()
		updateProfile()
	}
	
	func finishedCompletingItem(item: [String : String]) {
		createProjectTeamMate(item)
		getTeammates()
	}
	
	func userDidFinishEditingInterests(interests: [String]) {
		jobs = interests
		projectData["jobs"] = jobs
		tableView?.reloadData()
		updateProfile()
	}
	
	// MARK: Updating
	
	func updateProfile() {
		if NSUserDefaults.standardUserDefaults().objectForKey("projectId") != nil {
			for parameter in profileParameters {
				if projectData[parameter] == nil {
					projectData[parameter] = NSNull()
				}
			}
			let id = String(NSUserDefaults.standardUserDefaults().objectForKey("projectId") as! Int)
			ProjectHelper.updateProjectProfile(id, fullProfileData: projectData, completionHandler: { (response) in
				//				print(response)
				if response == true {
					self.getProfile()
				}
			})
		} else {
			ProjectHelper.createProject(projectData, completionHandler: { (response, fullProfile) in
				if response == true {
					print(fullProfile)
					let id = fullProfile!["id"]
					self.fullProjectData = fullProfile!
					NSUserDefaults.standardUserDefaults().setObject(id, forKey: "projectId")
					NSUserDefaults.standardUserDefaults().synchronize()
				}
			})
		}
	}
	
	func createProjectTeamMate(teamMate: [String: String]) {
		if let id = NSUserDefaults.standardUserDefaults().objectForKey("projectId") {
			let idString = String(id as! Int)
			ProjectHelper.createProjectTeamMate(idString, teammate: teamMate, completionHandler: { (response) in
				if response == true {
					print("Created a new team mate")
					self.teamData.append(teamMate)
					self.projectData["team"] = self.teamData
					self.tableView?.reloadData()
				}
			})
		}
	}
}