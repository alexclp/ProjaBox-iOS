//
//  ChatListViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 23/04/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		self.tableView?.separatorColor = UIColor(red: 242/256, green: 242/256, blue: 242/256, alpha: 1.0)
		self.tableView?.tableFooterView = UIView.init()
		
		self.tabBarController?.navigationItem.title = "Message List"
    }
	
	// MARK: Table View Data Source
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let rows = 3
		
		return rows
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("chatListCell", forIndexPath: indexPath) as! ChatListTableViewCell
		
		return cell
	}
	
	// MARK: Table View Delegate

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		performSegueWithIdentifier("showConversationSegue", sender: self)
	}
}
