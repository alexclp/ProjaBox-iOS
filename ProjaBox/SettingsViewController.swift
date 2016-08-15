//
//  SettingsViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 11/05/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var tableView: UITableView?
	
	let cellTitles = [1: ["My Profile", "My Posts"], 2: ["My Settings"], 3: ["Questions and Answers", "About"], 4: ["Log out"]]
	
	var myProfileData = [String: AnyObject]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		tableView?.registerNib(UINib(nibName: "ProfileTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "profileCell")
		tableView?.registerNib(UINib(nibName: "SettingsTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "settingsCell")
		
		self.navigationItem.title = "Settings"
		getMyProfile()
	}
	
	func getMyProfile() {
		ProfileHelper.getMyFullProfile { (response, data) in
			if response == true {
				if let data = data {
					self.myProfileData = data
					self.tableView?.reloadData()
				}
			}
		}
	}
	
	// MARK: Table View Data Source
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 0 {
			return 6.0
		}
		
		return 1.0
	}
	
	func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 5.0
	}
	
	func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return UIView.init(frame: CGRectZero)
	}
	
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return UIView.init(frame: CGRectZero)
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if (indexPath.section == 0) {
			return 189.0
		}
		
		return 57.0
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (section == 0 || section == 2 || section == 4) {
			return 1
		}
		
		return 2
		
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 5
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		if (indexPath.section == 0) {
			let cell = tableView.dequeueReusableCellWithIdentifier("profileCell", forIndexPath: indexPath) as! ProfileTableViewCell
			cell.editButton!.hidden = true
			cell.nameLabel?.text = myProfileData["name"] as? String
			cell.positionLabel?.text = myProfileData["occupation"] as? String
			
			if let imageURL = myProfileData["avatar"] {
				Alamofire.request(.GET, (imageURL as! String))
					.responseImage { response in
						if let image = response.result.value {
							cell.profileImageView?.image = image
						}
				}
			}
			return cell
		}
		
		let cell = tableView.dequeueReusableCellWithIdentifier("settingsCell", forIndexPath: indexPath) as! SettingsTableViewCell
		cell.cellTitleLabel?.text = cellTitles[indexPath.section]![indexPath.row]
		cell.cellAccessoryImageView?.image = UIImage(named: "accessory-view.png")
		cell.cellImageView?.image = UIImage(named: cellTitles[indexPath.section]![indexPath.row] + ".png")
		
		return cell
	}
	
	// MARK: Table View Delegate
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		if indexPath.section == 1 {
			if indexPath.row == 0 {
				performSegueWithIdentifier("showMyProfileSegue", sender: self)
			} else {
				performSegueWithIdentifier("showMyPostsSegue", sender: self)
			}
		} else if indexPath.section == 2 {
			performSegueWithIdentifier("showMoreSettingsSegue", sender: self)
		} else if indexPath.section == 4 {
			SignInHelper.signOut({ (response) in
				if response == true {
					self.performSegueWithIdentifier("logoutSegue", sender: self)
				}
			})
		}
	}
	
}
