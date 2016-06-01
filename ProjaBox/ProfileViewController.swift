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
		
		self.title = "Profile"
	}
	
	// MARK: UITableView Methods
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let rows = 0
		
		return rows
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		// STATIC VALUE FOR ALL CELLS EXCEPT INTERESTS
		// FOR INTERESTS GET HEIGHT FROM TAG LIST VIEW AND RETURN
		
		return 0.0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath)
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
}
