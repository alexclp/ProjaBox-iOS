//
//  PostDetailsViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 28/04/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class PostDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var postDetailsTableView: UITableView?
	@IBOutlet weak var commentTextField: UITextField?
	@IBOutlet weak var postButton: UIBarButtonItem?
	
	var commentsData = [[String: AnyObject]]()
	
	var selectedPost = UserPost()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		postDetailsTableView!.registerNib(UINib(nibName: "PostDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "postDetailsCell")
		postDetailsTableView!.registerNib(UINib(nibName: "PhotoPostDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "photoPostDetailsCell")
		postDetailsTableView!.registerNib(UINib(nibName: "LikesTableViewCell", bundle: nil), forCellReuseIdentifier: "likesCell")
		postDetailsTableView!.registerNib(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "commentCell")
		
		fillData()
		
	}
	
	func fillData() {
		if let comments = selectedPost.comments {
			commentsData = comments
			print("comments data: \(comments)")
		}
		postDetailsTableView?.reloadData()
	}
	
	// MARK: Table View Data Source
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return 250.0
		} else if indexPath.row == 1 {
			return 115
		} else {
			return 104.0
		}
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if commentsData.count != 0 {
			return 2 + commentsData.count
		}
		return 2
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		if indexPath.row == 0 {
			
			if let imageURL = selectedPost.image {
				let cell = tableView.dequeueReusableCellWithIdentifier("photoPostDetailsCell", forIndexPath: indexPath) as! PhotoPostDetailsTableViewCell
				cell.selectionStyle = .None
				
				let tap = UITapGestureRecognizer(target: self, action: #selector(self.nameButtonPressed(_:)))
				cell.nameLabel?.addGestureRecognizer(tap)
				cell.profileImageView?.addGestureRecognizer(tap)
				
				cell.likeButton?.addTarget(self, action: #selector(PostDetailsViewController.likePressed(_:)), forControlEvents: .TouchUpInside)
				cell.shareButton?.addTarget(self, action: #selector(PostDetailsViewController.sharePressed(_:)), forControlEvents: .TouchUpInside)
				cell.commentsButton?.addTarget(self, action: #selector(PostDetailsViewController.commentPressed(_:)), forControlEvents: .TouchUpInside)
				cell.moreButton?.addTarget(self, action: #selector(PostDetailsViewController.morePressed(_:)), forControlEvents: .TouchUpInside)
				
				//				cell.contentLabel?.text = selectedPost.content
				Alamofire.request(.GET, imageURL)
					.responseImage { response in
						if let image = response.result.value {
							print("image downloaded: \(image)")
							cell.postPhoto?.image = image
						}
				}
				if let likersData = selectedPost.likers {
					cell.likesLabel?.text = String(likersData.count)
				}
				
				if selectedPost.isLikedByMe == true {
					cell.likeButton?.selected = true
				}
				
				cell.timeLabel?.text = NewsFeedHelper.getTimeFromTimestamp(selectedPost.createdTimestamp!)
				
				if selectedPost is ProjectPost {
					let projectPost = selectedPost as! ProjectPost
					if let name = projectPost.projectName {
						cell.nameLabel?.text = name
					}
					
					if let url = projectPost.ownerAvatar {
						Alamofire.request(.GET, url)
							.responseImage { response in
								if let image = response.result.value {
									print("image downloaded: \(image)")
									cell.profileImageView!.image = image
								}
						}
					}
				} else {
					if let name = selectedPost.ownerName {
						cell.nameLabel?.text = name
					}
					
					if let url = selectedPost.ownerAvatar {
						Alamofire.request(.GET, url)
							.responseImage { response in
								if let image = response.result.value {
									print("image downloaded: \(image)")
									cell.profileImageView!.image = image
								}
						}
					}
				}
				
				
				return cell
			} else {
				let cell = tableView.dequeueReusableCellWithIdentifier("postDetailsCell", forIndexPath: indexPath) as! PostDetailsTableViewCell
				cell.selectionStyle = .None
				
				let tap = UITapGestureRecognizer(target: self, action: #selector(self.nameButtonPressed(_:)))
				cell.nameLabel?.addGestureRecognizer(tap)
				cell.profileImageView?.addGestureRecognizer(tap)
				
				cell.likeButton?.addTarget(self, action: #selector(PostDetailsViewController.likePressed(_:)), forControlEvents: .TouchUpInside)
				cell.shareButton?.addTarget(self, action: #selector(PostDetailsViewController.sharePressed(_:)), forControlEvents: .TouchUpInside)
				cell.commentsButton?.addTarget(self, action: #selector(PostDetailsViewController.commentPressed(_:)), forControlEvents: .TouchUpInside)
				cell.moreButton?.addTarget(self, action: #selector(PostDetailsViewController.morePressed(_:)), forControlEvents: .TouchUpInside)
				
				cell.contentLabel?.text = selectedPost.content
				if let likersData = selectedPost.likers {
					cell.likesLabel?.text = String(likersData.count)
				}
				
				if selectedPost.isLikedByMe == true {
					cell.likeButton?.selected = true
				}
				
				cell.timeLabel?.text = NewsFeedHelper.getTimeFromTimestamp(selectedPost.createdTimestamp!)
				
				
				if selectedPost is ProjectPost {
					let projectPost = selectedPost as! ProjectPost
					if let name = projectPost.projectName {
						cell.nameLabel?.text = name
					}
					
					if let url = projectPost.ownerAvatar {
						Alamofire.request(.GET, url)
							.responseImage { response in
								if let image = response.result.value {
									print("image downloaded: \(image)")
									cell.profileImageView!.image = image
								}
						}
					}
				} else {
					if let name = selectedPost.ownerName {
						cell.nameLabel?.text = name
					}
					
					if let url = selectedPost.ownerAvatar {
						Alamofire.request(.GET, url)
							.responseImage { response in
								if let image = response.result.value {
									print("image downloaded: \(image)")
									cell.profileImageView!.image = image
								}
						}
					}
				}
				
				return cell
			}
			
		} else if indexPath.row == 1 {
			
			// 7 images in total for the likes table view cell
			// if likes >= 7 make the last one as a three dot icon (to show that there are many likes for the post)
			
			let cell = tableView.dequeueReusableCellWithIdentifier("likesCell", forIndexPath: indexPath) as! LikesTableViewCell
			cell.profileImageView1?.hidden = false
			cell.profileImageView1?.image = UIImage(named: "profile_pic.jpg")
			cell.selectionStyle = .Gray
			
			return cell
			
		}
		
		let currentComment = commentsData[indexPath.row - 2]
		
		let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentTableViewCell
		cell.selectionStyle = .None
		if let ownerName = currentComment["ownerName"] {
			cell.nameLabel?.text = ownerName as? String
		}
		if let created = currentComment["created"] {
			cell.timeLabel?.text = NewsFeedHelper.getTimeFromTimestamp(created as! Int)
		}
		cell.commentLabel?.text = currentComment["content"] as? String
		
		return cell
	}
	
	// MARK: Table View Delegate
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
	// MARK: User Interaction
	
	@IBAction func postCommentPressed(sender: UIBarButtonItem) {
		let postContent = commentTextField?.text
		let postId = selectedPost.id
		
		NewsFeedHelper.createComment(String(postId!), commentContent: postContent!) { (response, data) in
			self.commentTextField?.resignFirstResponder()
			self.commentTextField?.text = ""
			
			if response == true {
				print("Comment success")
				
				if let data = data {
					self.commentsData.append(data)
					self.postDetailsTableView?.reloadData()
				}
			} else {
				print("Comment failed")
			}
		}
	}
	
	func likePressed(sender: UIButton) {
		let postId = selectedPost.id
		if sender.selected == false {
			NewsFeedHelper.likePost(String(postId!)) { (response) in
				if response == true {
					print("Liked successfully")
					sender.selected = true
					let cell = self.postDetailsTableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! PostDetailsTableViewCell
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
					let cell = self.postDetailsTableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! PostDetailsTableViewCell
					cell.likesLabel?.text = String(Int((cell.likesLabel?.text)!)! - 1)
				} else {
					print("Error while unliking post id: \(postId)")
				}
			})
		}
	}
	
	func sharePressed(sender: UIButton) {
		print("Share button tag: \(sender.tag)")
		if let shareController = SharingHelper.shareStandardText() {
			presentViewController(shareController, animated: true, completion: nil)
		}
	}
	
	func commentPressed(sender: UIButton) {
		
	}
	
	func morePressed(sender: UIButton) {
		
	}
	
	func nameButtonPressed(sender: UIGestureRecognizer) {
		if selectedPost is ProjectPost {
			performSegueWithIdentifier("feedShowProjectProfile", sender: self)
		} else {
			performSegueWithIdentifier("feedShowProfile", sender: self)
		}
	}
	
	// MARK: SEGUE
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "feedShowProfile" {
			let destination = segue.destinationViewController as! PersonProfileViewController
			let id = String(selectedPost.id!)
			destination.userId = id
		} else if segue.identifier == "feedShowProjectProfile" {
			let destination = segue.destinationViewController as! ProjectViewOnlyViewController
			let id = String(selectedPost.id!)
			destination.projectId = id
		}
	}
}
