//
//  ProfileViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 27/03/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var tableView: UITableView?

	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView!.registerNib(UINib(nibName: "EducationExperienceTableViewCell", bundle: nil), forCellReuseIdentifier: "educationExpercienceCell")
		tableView!.registerNib(UINib(nibName: "ProfileHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "profileHeaderCell")
		tableView!.registerNib(UINib(nibName: "InterestsTableViewCell", bundle: nil), forCellReuseIdentifier: "interestsCell")
		tableView!.registerNib(UINib(nibName: "FeedCardTableViewCell", bundle: nil), forCellReuseIdentifier: "cardCell")
		
		self.title = "Profile"
	}
	
	// MARK: UITableView Methods
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 4
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let rows = 0
		
		return rows
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		// STATIC VALUE FOR ALL CELLS EXCEPT INTERESTS
		// FOR INTERESTS GET HEIGHT FROM TAG LIST VIEW AND RETURN
		
		if indexPath.section == 0 {
			return 293.0
		} else if indexPath.section == 1 {
			let cell = tableView.cellForRowAtIndexPath(indexPath) as! InterestsTableViewCell
			let height = cell.tagListView?.bounds.height
			return height!
		} else if indexPath.section == 2 {
			return 115.0
		} else {
			return 221.0
		}
 	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCellWithIdentifier("profileHeaderCell", forIndexPath: indexPath) as! ProfileTableViewCell
			
			return cell
		} else if indexPath.section == 1 {
			let cell = tableView.dequeueReusableCellWithIdentifier("interestsCell", forIndexPath: indexPath) as! InterestsTableViewCell
			
			return cell
		} else if indexPath.section == 2 {
			let cell = tableView.dequeueReusableCellWithIdentifier("educationExperienceCell", forIndexPath: indexPath) as! EducationExperienceTableViewCell
			
			return cell
		} else {
			let cell = tableView.dequeueReusableCellWithIdentifier("cardCell", forIndexPath: indexPath) as! FeedCardTableViewCell
			
			return cell
		}
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
}
