//
//  ProfileViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 27/03/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ExperienceInputDelegate {
	
	@IBOutlet weak var tableView: UITableView?
	
	let educationData = [[String: String]]()
	let experienceData = [[String: AnyObject]]()
	let interestsData = [String]()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView!.registerNib(UINib(nibName: "EducationExperienceTableViewCell", bundle: nil), forCellReuseIdentifier: "educationExperienceCell")
		tableView!.registerNib(UINib(nibName: "ProfileHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "profileHeaderCell")
		tableView!.registerNib(UINib(nibName: "InterestsTableViewCell", bundle: nil), forCellReuseIdentifier: "interestsCell")
		tableView!.registerNib(UINib(nibName: "FeedCardTableViewCell", bundle: nil), forCellReuseIdentifier: "cardCell")
		
		self.title = "My profile"
		
		ProfileHelper.getMyFullProfile { (response) in
			
		}
	}
	
	// MARK: UITableView Methods
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 1 {
			return "Interests"
		} else if section == 2 {
			return "Education"
		} else if section == 3 {
			return "Experience"
		} else if section == 4 {
			return "Posts"
		}
		return ""
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 5
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let rows = 1
		
		return rows
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section == 0 {
			return 293.0
		} else if indexPath.section == 1 {
//			let cell = tableView.cellForRowAtIndexPath(indexPath) as! InterestsTableViewCell
//			let height = cell.tagListView?.bounds.height
//			return height!
			return 115.0
		} else if indexPath.section == 2 || indexPath.section == 3 {
			return 115.0
		} else {
			return 221.0
		}
 	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			// HEADER PART
			let cell = tableView.dequeueReusableCellWithIdentifier("profileHeaderCell", forIndexPath: indexPath) as! ProfileHeaderTableViewCell
			
			return cell
		} else if indexPath.section == 1 {
			// SKILLS/INTERESTS
			let cell = tableView.dequeueReusableCellWithIdentifier("interestsCell", forIndexPath: indexPath) as! InterestsTableViewCell
			cell.tagListView?.addTag("Press to add interests")
			
			return cell
		} else if indexPath.section == 2 {
			// EDUCATION
			let cell = tableView.dequeueReusableCellWithIdentifier("educationExperienceCell", forIndexPath: indexPath) as! EducationExperienceTableViewCell
			
			if educationData.count == 0 {
				cell.companyNameLabel?.text = "Add past education"
			} else {
				
			}
			
			return cell
		} else if indexPath.section == 3 {
			// EXPERIENCE
			let cell = tableView.dequeueReusableCellWithIdentifier("educationExperienceCell", forIndexPath: indexPath) as! EducationExperienceTableViewCell
			
			if experienceData.count == 0 {
				cell.companyNameLabel?.text = "Add past experience"
			}
			
			return cell
		} else {
			// POSTS
			let cell = tableView.dequeueReusableCellWithIdentifier("cardCell", forIndexPath: indexPath) as! FeedCardTableViewCell
			
			return cell
		}
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		if indexPath.section == 1 {
			
		} else if indexPath.section == 2 {
			performSegueWithIdentifier("editEducationSegue", sender: self)
		} else if indexPath.section == 3 {
			performSegueWithIdentifier("editExperienceSegue", sender: self)
		}
	}
	
	// MARK: Segue
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "editEducationSegue" {
			let destination = segue.destinationViewController as! EditEducationViewController
			destination.delegate = self
		} else if segue.identifier == "editExperienceSegue" {
			let destination = segue.destinationViewController as! EditExperienceViewController
			destination.delegate = self
		}
 	}
	
	// MARK: User interaction
	
	func editPersonalInfoPressed(sender: UIButton) {
		
	}
	
	func editInterestsButtonPressed(sender: UIButton) {
		
	}
	
	func editEducationPressed(sender: UIButton) {
		
	}
	
	func editExperiencePressed(sender: UIButton) {
		
	}
	
	// MARK: Finished entering data delegate
	
	func finishedCompletingItem(item: [String : String]) {
		
	}
}
