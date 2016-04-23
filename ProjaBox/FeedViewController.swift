//
//  FeedViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 27/03/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tabBarController!.navigationItem.title = "Projabox"
		self.tabBarController!.navigationItem.hidesBackButton = true
		
		setupBarButtons()
	}
	
	func setupBarButtons() {
		self.tabBarController!.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "messages.png"), style: .Plain, target: self, action: #selector(FeedViewController.chatButtonPressed(_:)))
		self.tabBarController!.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "settings.png"), style: .Plain, target: self, action: #selector(FeedViewController.settingsButtonPressed(_:)))
	}
	
	//	MARK: UITableView Data Source
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let rows = 10
		return rows
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("cardCell", forIndexPath: indexPath) as! FeedCardTableViewCell
		
		cell.likeButton?.tag = indexPath.row
		cell.likeButton?.addTarget(self, action: #selector(FeedViewController.likeButtonPressed(_:)), forControlEvents: .TouchUpInside)
		
		cell.shareButton?.tag = indexPath.row
		cell.shareButton?.addTarget(self, action: #selector(FeedViewController.shareButtonPressed(_:)), forControlEvents: .TouchUpInside)
		
		cell.messageButton?.tag = indexPath.row
		cell.messageButton?.addTarget(self, action: #selector(FeedViewController.messageButtonPressed(_:)), forControlEvents: .TouchUpInside)
		
		cell.moreButton?.tag = indexPath.row
		cell.moreButton?.addTarget(self, action: #selector(FeedViewController.moreButtonPressed(_:)), forControlEvents: .TouchUpInside)
		
		return cell
	}
	
	//	MARK: UITableView Delegate
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
	// MARK: User Interaction
	
	func likeButtonPressed(sender: UIButton) {
		print("Like button tag: \(sender.tag)")
		sender.selected = true
	}
	
	func shareButtonPressed(sender: UIButton) {
		print("Share button tag: \(sender.tag)")
	}
	
	func messageButtonPressed(sender: UIButton) {
		print("Message button tag: \(sender.tag)")
	}
	
	func moreButtonPressed(sender: UIButton) {
		print("More button tag: \(sender.tag)")
	}
	
	func settingsButtonPressed(sender: UIBarButtonItem) {
		
	}
	
	func chatButtonPressed(sender: UIBarButtonItem) {
		performSegueWithIdentifier("showChatSegue", sender: self)
	}
	
}
