//
//  ProjectViewOnlyViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 17/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import SKPhotoBrowser

class ProjectViewOnlyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
	
	@IBOutlet weak var tableView: UITableView?
	
	var headerData = [String: String]()
	var teamData = [[String: AnyObject]]()
	var postsData = [ProjectPost]()
	var goals = String()
	var jobs = [String]()
	
	var fullProjectData = [String: AnyObject]()
	var projectData = [String: AnyObject]()
	var collectionViewSourceArray = [[String: AnyObject]]()
	
	var projectId = String()
	
	let profileParameters = ["type", "name", "goals", "avatar", "description", "location", "video", "links", "jobs"]
	
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
		
		getProfile()
		
	}
	
	func setupBarButtons() {
		
	}
	
	func getProfile() {
		ProjectHelper.getFullProjectProfile(projectId, completionHandler: { (response, data) in
			print("project id: \(self.projectId)")
			if response == true {
				print(data)
				self.getLatestPosts()
				self.getProjectPhotos()
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
	
	func getLatestPosts() {
		ProjectHelper.getProjectsLatestPosts(projectId) { (response, posts) in
			if response == true {
				print("GOT PROJECT'S POSTS")
				self.postsData = posts!
				self.tableView?.reloadData()
			}
		}
	}
	
	func getProjectPhotos() {
		ProjectHelper.getProjectPhotos(projectId) { (response, data) in
			print("response: \(response)")
			if response == true {
				self.collectionViewSourceArray = data!
				print("image array = \(self.collectionViewSourceArray)")
				self.tableView?.reloadData()
			}
		}
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
			cell.statusLabel?.hidden = true
			cell.tagsLabel?.hidden = true
			cell.editButton?.hidden = true
			
			cell.likeButton?.addTarget(self, action: #selector(self.likeButtonPressed(_:)), forControlEvents: .TouchUpInside)
			cell.followButton?.addTarget(self, action: #selector(self.followButtonPressed(_:)), forControlEvents: .TouchUpInside)
			cell.messageButton?.addTarget(self, action: #selector(self.messageButtonPressed(_:)), forControlEvents: .TouchUpInside)
			
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
			
			if let likers = fullProjectData["likers"] as? [[String: AnyObject]] {
				cell.likeLabel?.text = String(likers.count)
			}
			
			if let isLikedByMe = fullProjectData["isLikedByMe"] as? Int {
				if isLikedByMe == 1 {
					cell.likeButton?.selected = true
				} else {
					cell.likeButton?.selected = false
				}
			}
			
			if let followers = fullProjectData["followers"] as? [[String: AnyObject]] {
				cell.followersLabel?.text = String(followers.count)
			}
			
			if let isFollowedByMe = fullProjectData["isFollowedByMe"] as? Int {
				if isFollowedByMe == 1 {
					cell.followButton?.selected = true
				} else {
					cell.followButton?.selected = false
				}
			}
			
			return cell
		} else if section == 1 {
			// TODO: Video section
		} else if section == 2 {
			// GOALS
			let cell = tableView.dequeueReusableCellWithIdentifier("goalsCell", forIndexPath: indexPath) as! GoalsTableViewCell
			cell.editButton?.hidden = true
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
			cell.editButton?.hidden = true
			
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
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionPhotoCell", forIndexPath: indexPath)
		let imageURL = collectionViewSourceArray[indexPath.item]["image"]
		print("IMAGE URL: \(imageURL)")
		Alamofire.request(.GET, (imageURL as! String))
			.responseImage { response in
				if let image = response.result.value {
					print("image downloaded: \(image)")
					let imageView = UIImageView(image: image)
					imageView.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
					imageView.contentMode = .ScaleToFill
					cell.addSubview(imageView)
				}
		}
		
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		var images = [SKPhoto]()
		
		for imageBundle in collectionViewSourceArray {
			let photo = SKPhoto.photoWithImageURL(imageBundle["image"] as! String)
			photo.shouldCachePhotoURLImage = true // you can use image cache by true(NSCache)
			images.append(photo)
		}
		
		// create PhotoBrowser Instance, and present.
		let browser = SKPhotoBrowser(photos: images)
		presentViewController(browser, animated: true, completion: {})
	}
	
	// MARK: User Interaction
	
	func likeButtonPressed(sender: UIButton) {
		if sender.selected == false {
			ProjectHelper.likeProject(projectId) { (response) in
				if response == true {
					let cell = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ProfileHeaderTableViewCell
					cell.likeLabel!.text = String(Int((cell.likeLabel!.text)!)! + 1)
					cell.likeButton?.selected = true
				}
			}
		} else {
			ProjectHelper.unlikeProject(projectId, completionHandler: { (response) in
				if response == true {
					let cell = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ProfileHeaderTableViewCell
					cell.likeLabel!.text = String(Int((cell.likeLabel!.text)!)! - 1)
					cell.likeButton?.selected = false
				}
			})
		}
	}
	
	func followButtonPressed(sender: UIButton) {
		if sender.selected == false {
			ProjectHelper.followProject(projectId, completionHandler: { (response) in
				if response == true {
					let cell = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ProfileHeaderTableViewCell
					cell.followersLabel!.text = String(Int((cell.followersLabel!.text)!)! + 1)
					cell.followButton?.selected = true
				}
			})
		} else {
			ProjectHelper.unFollowProject(projectId, completionHandler: { (response) in
				if response == true {
					let cell = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ProfileHeaderTableViewCell
					cell.followersLabel!.text = String(Int((cell.followersLabel!.text)!)! - 1)
					cell.followButton?.selected = false
				}
			})
		}
	}
	
	func messageButtonPressed(sender: UIButton) {
		performSegueWithIdentifier("showChatSegue", sender: self)
	}
	
	// MARK: Segue
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showChatSegue" {
			let destination = segue.destinationViewController as! ConversationViewController
			destination.profileId = projectId
		}
	}
}
