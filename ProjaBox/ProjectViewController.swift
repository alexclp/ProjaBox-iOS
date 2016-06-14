//
//  ProjectViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 27/03/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BioDataDelegate, GoalsInputDelegate, ExperienceInputDelegate, InterestsInputDelegate {
	
	@IBOutlet weak var tableView: UITableView?
	
	var headerData = [String: String]()
	var teamData = [[String: String]]()
	var postsData = [ProjectPost]()
	var goals = String()
	var jobs = [String]()
	
	var fullProjectData = [String: AnyObject]()
//	var projectData: [String: AnyObject?] = ["type": nil, "name": nil, "goals": nil, "description": nil, "location": nil, "video": nil, "links": nil, "jobs": nil]
	var projectData = [String: AnyObject]()
	
	let profileParameters = ["type", "name", "goals", "avatar", "description", "location", "video", "links", "jobs"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		tableView!.registerNib(UINib(nibName: "EducationExperienceTableViewCell", bundle: nil), forCellReuseIdentifier: "educationExperienceCell")
		tableView!.registerNib(UINib(nibName: "ProfileHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "profileHeaderCell")
		tableView!.registerNib(UINib(nibName: "InterestsTableViewCell", bundle: nil), forCellReuseIdentifier: "interestsCell")
		tableView!.registerNib(UINib(nibName: "FeedCardTableViewCell", bundle: nil), forCellReuseIdentifier: "cardCell")
		tableView!.registerNib(UINib(nibName: "GoalsTableViewCell", bundle: nil), forCellReuseIdentifier: "goalsCell")
		tableView!.registerNib(UINib(nibName: "PhotosTableViewCell", bundle: nil), forCellReuseIdentifier: "photosCell")
	
		teamData.append(["name": "Click me to add a team member"])
		
		getProfile()
	}
	
	func getProfile() {
		if NSUserDefaults.standardUserDefaults().objectForKey("projectId") != nil {
			
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
			
			return cell
		} else if section == 1 {
			// TODO: Video section
		} else if section == 2 {
			// GOALS
			let cell = tableView.dequeueReusableCellWithIdentifier("goalsCell", forIndexPath: indexPath) as! GoalsTableViewCell
			cell.goalsTextView?.text = goals
			
			return cell
		} else if section == 3 {
			// PHOTOS
			let cell = tableView.dequeueReusableCellWithIdentifier("photosCell", forIndexPath: indexPath)
			
			return cell
		} else if section == 4 {
			// TEAM SECTION
			let cell = tableView.dequeueReusableCellWithIdentifier("educationExperienceCell", forIndexPath: indexPath) as! EducationExperienceTableViewCell
			
			let currentTeamMember = teamData[indexPath.row]
			
			if let name = currentTeamMember["name"] {
				cell.companyNameLabel?.text = name
			}
			
			if let position = currentTeamMember["position"] {
				cell.positionLabel?.text = position
			}
			
			cell.periodLabel?.text = ""
			
			return cell
		} else if section == 5 {
			// JOB SECTION
			let cell = tableView.dequeueReusableCellWithIdentifier("interestsCell", forIndexPath: indexPath) as! InterestsTableViewCell
			
			return cell
		}
		
		// POST SECTION
		let cell = tableView.dequeueReusableCellWithIdentifier("cardCell", forIndexPath: indexPath)
			
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
	// MARK: User Interaction
	
	func editHeaderButtonPressed(sender: UIButton) {
		performSegueWithIdentifier("editProjectHeaderSegue", sender: self)
	}
	
	// MARK: Segue config
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "editProjectHeaderSegue" {
			let destination = segue.destinationViewController as! EditAboutProjectViewController
			destination.delegate = self
			destination.data = headerData
		}
	}
	
	// MARK: Forms Delegates Methods
	
	func userDidFinishCompletingData(bioData: [String : AnyObject]) {
		headerData["name"] = bioData["name"] as? String
		headerData["description"] = bioData["description"] as? String
		headerData["type"] = bioData["type"] as? String
		headerData["location"] = bioData["location"] as? String
		
		projectData["name"] = headerData["name"]
		projectData["description"] = headerData["description"]
		projectData["type"] = headerData["type"]
		projectData["location"] = headerData["location"]
		
		tableView?.reloadData()
		// TODO: Update online profile
		updateProfile()
	}
	
	func userFinishedEditingGoals(goals: String) {
		self.goals = goals
		projectData["goals"] = goals
		tableView?.reloadData()
		updateProfile()
	}
	
	func finishedCompletingItem(item: [String : String]) {
		teamData.append(item)
//		projectData![""] = 
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
			let id = NSUserDefaults.standardUserDefaults().objectForKey("projectId") as! String
			ProjectHelper.updateProjectProfile(id, fullProfileData: projectData, completionHandler: { (response) in
				print(response)
			})
		} else {
			ProjectHelper.createProject(projectData, completionHandler: { (response, fullProfile) in
				if response == true {
					print(fullProfile)
					let id = fullProfile!["id"]
					self.fullProjectData = fullProfile!
					NSUserDefaults.standardUserDefaults().setObject(id, forKey: "projectId")
				}
			})
		}
	}
	
	func createProjectTeamMate(teamMate: [String: String]) {
		
	}
}