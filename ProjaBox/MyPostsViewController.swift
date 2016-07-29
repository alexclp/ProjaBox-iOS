//
//  MyPostsViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 29/07/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MyPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	
	var posts = [UserPost]()
	let userData = NSUserDefaults.standardUserDefaults().objectForKey("userData")
	
    override func viewDidLoad() {
        super.viewDidLoad()

		tableView!.registerNib(UINib(nibName: "FeedCardTableViewCell", bundle: nil), forCellReuseIdentifier: "cardCell")
		tableView!.registerNib(UINib(nibName: "PhotoCardTableViewCell", bundle: nil), forCellReuseIdentifier: "photoCardCell")
		
		self.getLatestPosts()
    }
	
	func getLatestPosts() {
		ProfileHelper.getUsersLatestPosts(String(userData!["userId"] as! Int)) { (response, posts) in
			if response == true {
				self.posts = posts!
				self.tableView.reloadData()
			}
		}
	}
	
	// MARK: UITable View Data Source
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		let post = posts[indexPath.row]
		if post.image != nil {
			return 308.0
		}
		return 221.0
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return posts.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let currentPost = posts[indexPath.row]
		
		if let imageURL = currentPost.image {
			let cell = tableView.dequeueReusableCellWithIdentifier("photoCardCell", forIndexPath: indexPath) as! PhotoCardTableViewCell
			
			Alamofire.request(.GET, imageURL)
				.responseImage { response in
					if let image = response.result.value {
						print("image downloaded: \(image)")
						cell.postImage!.image = image
					}
			}
			
			if let likers = currentPost.likers {
				cell.likesLabel?.text = String(likers.count)
			}
			
			if let time = currentPost.createdTimestamp {
				cell.currentTimeLabel?.text = NewsFeedHelper.getTimeFromTimestamp(time)
			}
			
			if let name = currentPost.ownerName {
				cell.authorLabel?.text = name
			}
			
			cell.authorDetailsLabel?.hidden = true
			cell.authorLocationLabel?.hidden = true
			cell.locationImageView?.hidden = true
			
			if let url = currentPost.ownerAvatar {
				Alamofire.request(.GET, url)
					.responseImage { response in
						if let image = response.result.value {
							print("image downloaded: \(image)")
							cell.profileImageView!.image = image
						}
				}
			}
			
			return cell
		}
		
		let cell = tableView.dequeueReusableCellWithIdentifier("cardCell", forIndexPath: indexPath) as! FeedCardTableViewCell
		if let content = currentPost.content {
			cell.postLabel?.text = content
		}
		
		if let likers = currentPost.likers {
			cell.likesLabel?.text = String(likers.count)
		}
		
		if let time = currentPost.createdTimestamp {
			cell.currentTimeLabel?.text = NewsFeedHelper.getTimeFromTimestamp(time)
		}
		
		if let name = currentPost.ownerName {
			cell.authorLabel?.text = name
		}

		cell.authorDetailsLabel?.hidden = true
		cell.authorLocationLabel?.hidden = true
		cell.locationImageView?.hidden = true
		
		if let url = currentPost.ownerAvatar {
			Alamofire.request(.GET, url)
				.responseImage { response in
					if let image = response.result.value {
						print("image downloaded: \(image)")
						cell.profileImageView!.image = image
					}
			}
		}
		
		return cell

	}
	
	// MARK: UITable View Delegate
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
}
