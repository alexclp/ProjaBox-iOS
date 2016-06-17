//
//  FeedViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 27/03/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import SwiftSpinner

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet weak var tableView: UITableView?
	
	internal var postsData = [UserPost]()
	internal var selectedCellIndex = 0
	internal var selectedName = 0
	
	let imagePicker = UIImagePickerController()
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		getLatestPosts()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		setupBarButtons()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView!.registerNib(UINib(nibName: "FeedCardTableViewCell", bundle: nil), forCellReuseIdentifier: "cardCell")
		
		self.navigationController?.navigationBar.hidden = false
		
//		self.tabBarController!.navigationItem.title = "Feed"
		self.tabBarController!.navigationItem.hidesBackButton = true
		
		self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
		
		imagePicker.delegate = self
		imagePicker.navigationBar.translucent = false
		imagePicker.navigationBar.barTintColor = UIColor(red: 237/255, green: 84/255, blue: 84/255, alpha: 1.0) // Background color
		imagePicker.navigationBar.tintColor = .whiteColor() // Cancel button ~ any UITabBarButton items
		imagePicker.navigationBar.titleTextAttributes = [
			NSForegroundColorAttributeName : UIColor.whiteColor()
		] // Title color
		
		getLatestPosts()
	}
	
	func getLatestPosts() {
		SwiftSpinner.show("Loading data")
		NewsFeedHelper.getNewsFeed { (response, posts) in
			if response == true {
				if let data = posts {
					self.postsData = data
					self.tableView?.reloadData()
				}
				SwiftSpinner.hide()
			} else {
				
			}
			
		}
	}
	
	func setupBarButtons() {
		self.tabBarController?.navigationItem.titleView = nil
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
		
		cell.selectionStyle = .None
		cell.likeButton?.tag = indexPath.row
		cell.likeButton?.addTarget(self, action: #selector(FeedViewController.likeButtonPressed(_:)), forControlEvents: .TouchUpInside)
		cell.shareButton?.tag = indexPath.row
		cell.shareButton?.addTarget(self, action: #selector(FeedViewController.shareButtonPressed(_:)), forControlEvents: .TouchUpInside)
		cell.commentButton?.tag = indexPath.row
		cell.commentButton?.addTarget(self, action: #selector(FeedViewController.commentButtonPressed(_:)), forControlEvents: .TouchUpInside)
		cell.moreButton?.tag = indexPath.row
		cell.moreButton?.addTarget(self, action: #selector(FeedViewController.moreButtonPressed(_:)), forControlEvents: .TouchUpInside)
		
		cell.authorLocationLabel?.text = ""
		cell.locationImageView?.hidden = true
		cell.authorDetailsLabel?.text = ""
		cell.profileImageView?.image = nil
		
		let currentPost = postsData[indexPath.row]
		cell.postLabel?.text = currentPost.content
		cell.currentTimeLabel?.text = NewsFeedHelper.getTimeFromTimestamp(currentPost.createdTimestamp!)
		if let likers = currentPost.likers {
			cell.likesLabel?.text = String(likers.count)
		}
		if currentPost.isLikedByMe == true {
			cell.likeButton!.selected = true
		}
		
		if currentPost is ProjectPost {
			let projectPost = currentPost as! ProjectPost
			if let name = projectPost.projectName {
				let tap = UITapGestureRecognizer(target: self, action: #selector(self.nameButtonPressed(_:)))
				cell.authorLabel?.text = name
				cell.authorLabel!.tag = indexPath.row
				cell.authorLabel?.addGestureRecognizer(tap)
			}
		} else {
			if let name = currentPost.ownerName {
				let tap = UITapGestureRecognizer(target: self, action: #selector(self.nameButtonPressed(_:)))
				cell.authorLabel?.text = name
				cell.authorLabel!.tag = indexPath.row
				cell.authorLabel?.addGestureRecognizer(tap)
			}
		}
		
		return cell
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
					let cell = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) as! FeedCardTableViewCell
					cell.likesLabel?.text = String(Int((cell.likesLabel?.text)!)! + 1)
				} else {
					print("Error while liking post id: \(postId)")
				}
			}
		} else {
			NewsFeedHelper.unlikePost(String(postId!), completionHandler: { (response) in
				if response == true {
					print("Unliked successfully")
					sender.selected = false
					let cell = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) as! FeedCardTableViewCell
					cell.likesLabel?.text = String(Int((cell.likesLabel?.text)!)! - 1)
				} else {
					print("Error while unliking post id: \(postId)")
				}
			})
		}
		
	}
	
	func nameButtonPressed(sender: UIGestureRecognizer) {
		selectedName = (sender.view?.tag)!
		if postsData[selectedName] is ProjectPost {
			performSegueWithIdentifier("feedShowProjectProfile", sender: self)
		} else {
			performSegueWithIdentifier("feedShowProfile", sender: self)
		}
		
	}
	
	func shareButtonPressed(sender: UIButton) {
		print("Share button tag: \(sender.tag)")
	}
	
	func commentButtonPressed(sender: UIButton) {
		print("Comment button tag: \(sender.tag)")
		selectedCellIndex = sender.tag
		performSegueWithIdentifier("showPostDetailsSegue", sender: self)
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
	
	// MARK: Segue Methods
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showPostDetailsSegue" {
			let destinationController = segue.destinationViewController as! PostDetailsViewController
			destinationController.selectedPost = postsData[selectedCellIndex]
		} else if segue.identifier == "showSettingsSegue" {
			let backItem = UIBarButtonItem()
			backItem.title = ""
		} else if segue.identifier == "feedShowProfile" {
			let destination = segue.destinationViewController as! PersonProfileViewController
			let id = String(postsData[selectedName].ownerId!)
			destination.userId = id
		} else if segue.identifier == "feedShowProjectProfile" {
			let destination = segue.destinationViewController as! ProjectViewOnlyViewController
			let projectPost = postsData[selectedName] as! ProjectPost
			let id = String(projectPost.projectId!)
			destination.projectId = id
		}
	}
}
