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
	
	var selectedIndex = Int()
	var chatData = [[String: AnyObject]]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		self.tableView?.separatorColor = UIColor(red: 242/256, green: 242/256, blue: 242/256, alpha: 1.0)
		self.tableView?.tableFooterView = UIView.init()
		
		self.navigationItem.title = "Message List"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(self.createNewConversation(_:)))
		
		loadChatList()
	}
	
	func loadChatList() {
		ChatHelper.getChatList { (response, data) in
			if response == true {
				if let data = data {
					self.chatData = data
					print("chat data: \(self.chatData)")
					self.tableView?.reloadData()
				}
			}
		}
	}
	
	func createNewConversation(sender: UIBarButtonItem) {
		performSegueWithIdentifier("showPersonSearchSegue", sender: self)
	}
	
	// MARK: Table View Data Source
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let rows = chatData.count
		
		return rows
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("chatListCell", forIndexPath: indexPath) as! ChatListTableViewCell
		
		let current = chatData[indexPath.row]
		
		if let name = current["initiatorName"] {
			cell.nameLabel?.text = name as? String
		}
		
		if let lastMessage = current["message"] {
			cell.previewLabel?.text = lastMessage as? String
		}
		
		if let time = current["updated"] {
			cell.timeLabel?.text = NewsFeedHelper.getTimeFromTimestamp(time as! Int)
		}
		
		return cell
	}
	
	// MARK: Table View Delegate
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		selectedIndex = indexPath.row
		performSegueWithIdentifier("showConversationSegue", sender: self)
	}
	
	// MARK: Segue
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showConversationSegue" {
			let destination = segue.destinationViewController as! ConversationViewController
			let id = String(chatData[selectedIndex]["initiatorId"] as! Int)
			destination.profileId = id
		}
	}
}
