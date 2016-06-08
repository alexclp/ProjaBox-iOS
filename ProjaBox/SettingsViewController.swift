//
//  SettingsViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 11/05/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView?
	
	let cellTitles = [1: ["My Profile", "My Posts"], 2: ["My Settings"], 3: ["Questions and Answers", "About"], 4: ["Log out"]]
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		tableView?.registerNib(UINib(nibName: "ProfileTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "profileCell")
		tableView?.registerNib(UINib(nibName: "SettingsTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "settingsCell")
		
		self.navigationItem.title = "Settings"
    }

	// MARK: Table View Data Source
	
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
	}
	
}
