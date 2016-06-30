//
//  MoreSettingsViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 31/05/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class MoreSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var tableView: UITableView?
	
	let tableData = ["Personal info", "Notifications", "Blocked users", "Privacy", "Change password", "Delete account"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		tableView?.registerNib(UINib(nibName: "SettingsTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "settingsCell")
		
		self.navigationItem.title = "My settings"
	}
	
	// MARK: UITableView Methods
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let rows = tableData.count
		
		return rows
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("settingsCell", forIndexPath: indexPath) as! SettingsTableViewCell
		
		cell.cellTitleLabel?.text = tableData[indexPath.row]
		cell.cellImageView?.image = UIImage(named: tableData[indexPath.row] + ".png")
		cell.cellAccessoryImageView?.image = UIImage(named: "accessory-view.png")
		
		return cell
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 57.0
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
}
