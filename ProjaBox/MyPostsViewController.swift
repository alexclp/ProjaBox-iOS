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

class MyPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet weak var tableView: UITableView!
	
	var posts = [UserPost]()
	let userData = NSUserDefaults.standardUserDefaults().objectForKey("userData")
	var selectedCellIndex = 0
	var isEditingPost = false
	var editingPostIndex = 0
	let imagePicker = UIImagePickerController()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		tableView!.registerNib(UINib(nibName: "FeedCardTableViewCell", bundle: nil), forCellReuseIdentifier: "cardCell")
		tableView!.registerNib(UINib(nibName: "PhotoCardTableViewCell", bundle: nil), forCellReuseIdentifier: "photoCardCell")
		
		imagePicker.delegate = self
		imagePicker.navigationBar.translucent = false
		imagePicker.navigationBar.barTintColor = UIColor(red: 237/255, green: 84/255, blue: 84/255, alpha: 1.0) // Background color
		imagePicker.navigationBar.tintColor = .whiteColor() // Cancel button ~ any UITabBarButton items
		imagePicker.navigationBar.titleTextAttributes = [
			NSForegroundColorAttributeName : UIColor.whiteColor()
		] // Title color
		
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
	
	// MARK: Picker Delegate
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		dismissViewControllerAnimated(true, completion: nil)
		
		if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			let strBase64 = CompressedImage.encodeImageLowetQuality(pickedImage)
			if isEditingPost == true {
				let editedPost = posts[editingPostIndex]
				let postId = String(editedPost.id!)
				NewsFeedHelper.editPost(postId, content: ["image": strBase64], completionHandler: { (response) in
					print(response)
					self.isEditingPost = false
					self.getLatestPosts()
				})
			} else {
				NewsFeedHelper.createPhotoPost(strBase64, completionHandler: { (response) in
					self.getLatestPosts()
				})
			}
		}
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
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
			
			cell.likeButton?.tag = indexPath.row
			cell.likeButton?.addTarget(self, action: #selector(MyPostsViewController.likeButtonPressed(_:)), forControlEvents: .TouchUpInside)
			cell.shareButton?.tag = indexPath.row
			cell.shareButton?.addTarget(self, action: #selector(MyPostsViewController.shareButtonPressed(_:)), forControlEvents: .TouchUpInside)
			cell.commentButton?.tag = indexPath.row
			cell.commentButton?.addTarget(self, action: #selector(MyPostsViewController.commentButtonPressed(_:)), forControlEvents: .TouchUpInside)
			cell.moreButton?.tag = indexPath.row
			cell.moreButton?.addTarget(self, action: #selector(MyPostsViewController.moreButtonPressed(_:)), forControlEvents: .TouchUpInside)
			
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
		
		cell.likeButton?.tag = indexPath.row
		cell.likeButton?.addTarget(self, action: #selector(MyPostsViewController.likeButtonPressed(_:)), forControlEvents: .TouchUpInside)
		cell.shareButton?.tag = indexPath.row
		cell.shareButton?.addTarget(self, action: #selector(MyPostsViewController.shareButtonPressed(_:)), forControlEvents: .TouchUpInside)
		cell.commentButton?.tag = indexPath.row
		cell.commentButton?.addTarget(self, action: #selector(MyPostsViewController.commentButtonPressed(_:)), forControlEvents: .TouchUpInside)
		cell.moreButton?.tag = indexPath.row
		cell.moreButton?.addTarget(self, action: #selector(MyPostsViewController.moreButtonPressed(_:)), forControlEvents: .TouchUpInside)
		
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
	
	// MARK: User interaction
	
	func likeButtonPressed(sender: UIButton) {
		let postId = posts[sender.tag].id
		if sender.selected == false {
			NewsFeedHelper.likePost(String(postId!)) { (response) in
				if response == true {
					print("Liked successfully")
					sender.selected = true
					if self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) is PhotoCardTableViewCell {
						let cell = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) as! PhotoCardTableViewCell
						cell.likesLabel?.text = String(Int((cell.likesLabel?.text)!)! + 1)
					} else {
						let cell = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) as! FeedCardTableViewCell
						cell.likesLabel?.text = String(Int((cell.likesLabel?.text)!)! + 1)
					}
				} else {
					print("Error while liking post id: \(postId)")
				}
			}
		} else {
			NewsFeedHelper.unlikePost(String(postId!), completionHandler: { (response) in
				if response == true {
					print("Unliked successfully")
					sender.selected = false
					if self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) is PhotoCardTableViewCell {
						let cell = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) as! PhotoCardTableViewCell
						cell.likesLabel?.text = String(Int((cell.likesLabel?.text)!)! - 1)
					} else {
						let cell = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) as! FeedCardTableViewCell
						cell.likesLabel?.text = String(Int((cell.likesLabel?.text)!)! - 1)
					}
				} else {
					print("Error while unliking post id: \(postId)")
				}
			})
		}
		
	}
	
	func shareButtonPressed(sender: UIButton) {
		print("Share button tag: \(sender.tag)")
		if let shareController = SharingHelper.shareStandardText() {
			presentViewController(shareController, animated: true, completion: nil)
		}
	}
	
	func commentButtonPressed(sender: UIButton) {
		print("Comment button tag: \(sender.tag)")
		selectedCellIndex = sender.tag
		performSegueWithIdentifier("postDetailsSegue", sender: self)
	}
	
	func moreButtonPressed(sender: UIButton) {
		print("More button tag: \(sender.tag)")
		
		let alertController = UIAlertController(title: nil, message: "Edit or delete post", preferredStyle: .ActionSheet)
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
			self.dismissViewControllerAnimated(true, completion: nil)
		}
		alertController.addAction(cancelAction)
		
		let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) in
			let postId = String(self.posts[sender.tag].id!)
			NewsFeedHelper.deletePost(postId, completionHandler: { (response) in
				if response == true {
					self.posts.removeAtIndex(sender.tag)
					self.tableView?.reloadData()
				}
			})
		}
		alertController.addAction(deleteAction)
		
		let editAction = UIAlertAction(title: "Edit", style: .Default) { (action) in
			self.isEditingPost = true
			self.editingPostIndex = sender.tag
			
			if self.posts[self.editingPostIndex].image != nil {
				self.imagePicker.allowsEditing = false
				self.imagePicker.sourceType = .PhotoLibrary
				
				self.presentViewController(self.imagePicker, animated: true, completion: nil)
			} else {
				self.performSegueWithIdentifier("postingSegue", sender: self)
			}
		}
		alertController.addAction(editAction)
		
		presentViewController(alertController, animated: true, completion: nil)
	}
	
	// MARK: Segue
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "postDetailsSegue" {
			let destinationController = segue.destinationViewController as! PostDetailsViewController
			destinationController.selectedPost = posts[selectedCellIndex]
		} else if segue.identifier == "postingSegue" {
			let navCon = segue.destinationViewController as! UINavigationController
			let destination = navCon.viewControllers[0] as! CreatingPostViewController
			if isEditingPost == true {
				destination.isEditingPost = true
				let editingPost = posts[editingPostIndex]
				if editingPost is ProjectPost {
					let projectPost = editingPost as! ProjectPost
					destination.editedProjectPost = projectPost
				} else {
					destination.editedUserPost = editingPost
				}
			}
		}
	}
}
