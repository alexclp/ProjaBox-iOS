//
//  FeedViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 27/03/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet weak var tableView: UITableView?
	
	var postsData = [UserPost]()
	
	let imagePicker = UIImagePickerController()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView!.registerNib(UINib(nibName: "FeedCardTableViewCell", bundle: nil), forCellReuseIdentifier: "cardCell")
		
		self.navigationController?.navigationBar.hidden = false
		
		self.tabBarController!.navigationItem.title = "Projabox"
		self.tabBarController!.navigationItem.hidesBackButton = true
		
		self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
		
		imagePicker.delegate = self
		imagePicker.navigationBar.translucent = false
		imagePicker.navigationBar.barTintColor = UIColor(red: 237/255, green: 84/255, blue: 84/255, alpha: 1.0) // Background color
		imagePicker.navigationBar.tintColor = .whiteColor() // Cancel button ~ any UITabBarButton items
		imagePicker.navigationBar.titleTextAttributes = [
			NSForegroundColorAttributeName : UIColor.whiteColor()
		] // Title color
		
		setupBarButtons()
		getLatestPosts()
	}
	
	func getLatestPosts() {
		NewsFeedHelper.getNewsFeed { (response, posts) in
			if response == true {
				if let data = posts {
					self.postsData = data
					self.tableView?.reloadData()
				}
			}
		}
	}
	
	func setupBarButtons() {
		self.tabBarController!.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "messages.png"), style: .Plain, target: self, action: #selector(FeedViewController.chatButtonPressed(_:)))
		self.tabBarController!.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "settings.png"), style: .Plain, target: self, action: #selector(FeedViewController.settingsButtonPressed(_:)))
	}
	
	//	MARK: UITableView Data Source
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let rows = postsData.count
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
		
		let currentPost = postsData[indexPath.row]
		
		if currentPost is ProjectPost {
			
		} else {
			cell.postLabel?.text = currentPost.content
			cell.currentTimeLabel?.text = getTimeFromTimestamp(currentPost.createdTimestamp!)
			
			if currentPost.isLikedByMe == true {
				cell.likeButton!.selected = true
			}
		}
		
		return cell
	}
	
	private func getTimeFromTimestamp(timestamp: Int) -> String {
		let date = NSDate(timeIntervalSince1970: Double(timestamp))
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let calendar = NSCalendar.currentCalendar()
		let comp = calendar.components([.Hour, .Minute], fromDate: date)
		let hour = comp.hour
		let minute = comp.minute
		
		return "\(hour):\(minute)"
	}
	
	//	MARK: UITableView Delegate
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		performSegueWithIdentifier("showPostDetailsSegue", sender: self)
	}
	
	// MARK: Image Picker Delegate
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	// MARK: User Interaction
	
	func likeButtonPressed(sender: UIButton) {
		let postId = postsData[sender.tag].id
		if sender.selected == false {
			NewsFeedHelper.likePost(String(postId!)) { (response) in
				if response == true {
					print("Liked successfully")
					sender.selected = true
				} else {
					print("Error while liking post id: \(postId)")
				}
			}
		} else {
			NewsFeedHelper.unlikePost(String(postId!), completionHandler: { (response) in
				if response == true {
					print("Unliked successfully")
					sender.selected = false
				} else {
					print("Error while unliking post id: \(postId)")
				}
			})
		}
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
		performSegueWithIdentifier("showSettingsSegue", sender: self)
	}
	
	func chatButtonPressed(sender: UIBarButtonItem) {
		performSegueWithIdentifier("showChatSegue", sender: self)
	}
	
	@IBAction func postButtonPressed(sender: UIButton) {
		performSegueWithIdentifier("showComposePostSegue", sender: self)
	}
	
	@IBAction func photoButtonPressed(sender: UIButton) {
		imagePicker.allowsEditing = false
		imagePicker.sourceType = .PhotoLibrary
		
		presentViewController(imagePicker, animated: true, completion: nil)
	}
	
}
