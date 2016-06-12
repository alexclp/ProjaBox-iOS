//
//  ProjectViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 27/03/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var tableView: UITableView?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		tableView!.registerNib(UINib(nibName: "EducationExperienceTableViewCell", bundle: nil), forCellReuseIdentifier: "educationExperienceCell")
		tableView!.registerNib(UINib(nibName: "ProfileHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "profileHeaderCell")
		tableView!.registerNib(UINib(nibName: "InterestsTableViewCell", bundle: nil), forCellReuseIdentifier: "interestsCell")
		tableView!.registerNib(UINib(nibName: "FeedCardTableViewCell", bundle: nil), forCellReuseIdentifier: "cardCell")
		tableView!.registerNib(UINib(nibName: "GoalsTableViewCell", bundle: nil), forCellReuseIdentifier: "goalsCell")
		tableView!.registerNib(UINib(nibName: "PhotosTableViewCell", bundle: nil), forCellReuseIdentifier: "photosCell")
	}
	
	// MARK: UITableView Methods
//	
//	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//		
//	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 2 {
			return "Goals"
		} else if section == 3 {
			return "Photos"
		} else if section == 4 {
			return "Job"
		} else if section == 5 {
			return "Team"
		} else if section == 6 {
			return "Posts"
		}
		return ""
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 7
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 6 || section == 3 {
			// RETURN THE NO OF POSTS
			return 0
		} else {
			return 1
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let section = indexPath.section
		
		if section == 0 {
			// HEADER
			let cell = tableView.dequeueReusableCellWithIdentifier("profileHeaderCell", forIndexPath: indexPath) as! ProfileHeaderTableViewCell
			cell.editButton?.addTarget(self, action: #selector(self.editHeaderButtonPressed(_:)), forControlEvents: .TouchUpInside)
			
			return cell
		} else if section == 1 {
			// TODO: Video section
		} else if section == 2 {
			// GOALS
			let cell = tableView.dequeueReusableCellWithIdentifier("goalsCell", forIndexPath: indexPath) as! GoalsTableViewCell
			
			return cell
		} else if section == 3 {
			// PHOTOS
			let cell = tableView.dequeueReusableCellWithIdentifier("photosCell", forIndexPath: indexPath)
			
			return cell
		} else if section == 4 {
			// JOBS SECTION
			let cell = tableView.dequeueReusableCellWithIdentifier("educationExperienceCell", forIndexPath: indexPath) as! EducationExperienceTableViewCell
			
			return cell
		} else if section == 5 {
			// TEAM SECTION
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
	
	// User Interaction
	
	func editHeaderButtonPressed(sender: UIButton) {
		
	}
}