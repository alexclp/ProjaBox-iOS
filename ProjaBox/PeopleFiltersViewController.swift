//
//  PeopleFiltersViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 16/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class PeopleFiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var tableView: UITableView?
	
	let rowTitles = ["Occupation", "Location"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		tableView?.registerNib(UINib(nibName: "SettingsTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "settingsCell")
		self.title = "Filter People"
	}
	
	// MARK: Table View methods
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 57.0
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let rows = 2
		
		return rows
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("settingsCell") as! SettingsTableViewCell
		cell.cellTitleLabel?.text = rowTitles[indexPath.row]
		cell.cellAccessoryImageView?.image = UIImage(named: "accessory-view.png")
		cell.cellImageView?.image = UIImage(named: rowTitles[indexPath.row] + ".png")
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		if indexPath.row == 0 {
			// OCCUPATION
			//			performSegueWithIdentifier("showPeopleFiltersSegue", sender: self)
		} else {
			// LOCATION
			//			performSegueWithIdentifier("showProjectFilterSegue", sender: self)
		}
	}
}
