//
//  ProjectViewOnlyViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 17/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class ProjectViewOnlyViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView?
	
	var headerData = [String: String]()
	var teamData = [[String: String]]()
	var postsData = [ProjectPost]()
	var goals = String()
	var jobs = [String]()
	
	var fullProjectData = [String: AnyObject]()
	var projectData = [String: AnyObject]()
	
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
				if let name = data!["name"] {
					self.projectData["name"] = name as! String
					self.headerData["name"] = name as? String
				}
				
				if let description = data!["description"] {
					self.projectData["description"] = description as! String
					self.headerData["description"] = description as? String
				}
				
				if let location = data!["location"] {
					self.projectData["location"] = location as! String
					self.headerData["location"] = location as? String
				}
				
				if let goals = data!["goals"] as? String {
					self.projectData["goals"] = goals
					self.goals = goals
				}
				
				if let type = data!["type"] {
					self.projectData["type"] = type as! String
					self.headerData["type"] = type as? String
				}
				
				if let team = data!["team"] as? [String: String] {
					self.projectData["team"] = team
					self.teamData.append(team)
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
			return teamData.count
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
			cell.editButton?.hidden = true
			cell.statusLabel?.hidden = true
			cell.tagsLabel?.hidden = true
			cell.selectionStyle = .None
			
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
			let cell = tableView.dequeueReusableCellWithIdentifier("photosCell", forIndexPath: indexPath)
			
			return cell
		} else if section == 4 {
			// TEAM SECTION
			let cell = tableView.dequeueReusableCellWithIdentifier("educationExperienceCell", forIndexPath: indexPath) as! EducationExperienceTableViewCell
			cell.periodLabel?.text = ""
			let currentTeamMember = teamData[indexPath.row]
			
			if let name = currentTeamMember["name"] {
				cell.companyNameLabel?.text = name
			}
			
			if let position = currentTeamMember["position"] {
				cell.positionLabel?.text = position
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
		let cell = tableView.dequeueReusableCellWithIdentifier("cardCell", forIndexPath: indexPath) as! FeedCardTableViewCell
		
		cell.authorLocationLabel?.text = ""
		cell.locationImageView?.hidden = true
		cell.authorDetailsLabel?.text = ""
		//		cell.profileImageView?.image = nil
		
		let currentPost = postsData[indexPath.row]
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
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
}
