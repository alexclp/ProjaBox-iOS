//
//  PersonProfileViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 17/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import SwiftSpinner
import Alamofire
import AlamofireImage

class PersonProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var tableView: UITableView?
	
	var userId = String()
	
	var bioData = [String: AnyObject]()
	var educationData = [[String: String]]()
	var experienceData = [[String: String]]()
	var interestsData = [String]()
	var posts = [UserPost]()
	
	var fullProfileData = [String: AnyObject]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView!.registerNib(UINib(nibName: "EducationExperienceTableViewCell", bundle: nil), forCellReuseIdentifier: "educationExperienceCell")
		tableView!.registerNib(UINib(nibName: "ProfileHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "profileHeaderCell")
		tableView!.registerNib(UINib(nibName: "InterestsTableViewCell", bundle: nil), forCellReuseIdentifier: "interestsCell")
		tableView!.registerNib(UINib(nibName: "FeedCardTableViewCell", bundle: nil), forCellReuseIdentifier: "cardCell")
		tableView!.registerNib(UINib(nibName: "PhotoCardTableViewCell", bundle: nil), forCellReuseIdentifier: "photoCardCell")
		
		self.title = "Profile"
		
		SwiftSpinner.show("Loading")
		ProfileHelper.getUserFullProfile(userId) { (response, data) in
			if response == true {
				self.fullProfileData = data!
				self.tableView?.reloadData()
				self.getLatestPosts()
			} else {
				
			}
		}
	}
	
	func fillData() {
		let education = fullProfileData["education"]
		
		if (education as? [[String: String]] != nil) {
			educationData = fullProfileData["education"] as! [[String: String]]
		}
		
		let experience = fullProfileData["experience"]
		
		if (experience as? [[String: String]] != nil) {
			experienceData = fullProfileData["experience"] as! [[String : String]]
		}
		
		let interests = fullProfileData["interests"]
		
		if (interests as? [String]) != nil {
			interestsData = fullProfileData["interests"] as! [String]
		}
		
		// bio
		let name = fullProfileData["name"]
		
		if (name as? String) != nil {
			bioData["name"] = fullProfileData["name"] as! String
		}
		
		let location = fullProfileData["location"]
		
		if (location as? String) != nil {
			bioData["location"] = fullProfileData["location"] as! String
		}
		
		let occupation = fullProfileData["occupation"]
		
		if (occupation as? String) != nil {
			bioData["occupation"] = fullProfileData["occupation"] as! String
		}
		
		let status = fullProfileData["status"]
		
		if (status as? String) != nil {
			bioData["status"] = fullProfileData["status"] as! String
		}
		
		let about = fullProfileData["about"]
		
		if (about as? String) != nil {
			bioData["about"] = fullProfileData["about"]
		}
		
		let sex = fullProfileData["sex"]
		
		if (sex as? String) != nil {
			if !((fullProfileData["sex"] as! String).isEqual("U")) {
				bioData["sex"] = fullProfileData["sex"]
			}
		}
		
		//		tableView?.reloadData()
	}
	
	func getLatestPosts() {
		ProfileHelper.getUsersLatestPosts(String(fullProfileData["id"]!)) { (response, posts) in
			SwiftSpinner.hide()
			if response == true {
				self.posts = posts!
				self.tableView?.reloadData()
			}
		}
	}
	
	// MARK: UITableView Methods
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 1 {
			return "Interests"
		} else if section == 2 {
			return "Education"
		} else if section == 3 {
			return "Experience"
		} else if section == 4 {
			return "Posts"
		}
		return ""
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 5
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let rows = 1
		
		if section == 2 {
			return educationData.count
		} else if section == 3 {
			return experienceData.count
		} else if section == 4 {
			return posts.count
		}
		
		return rows
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section == 0 {
			return 293.0
		} else if indexPath.section == 1 {
			//			let cell = tableView.cellForRowAtIndexPath(indexPath) as! InterestsTableViewCell
			//			let height = cell.tagListView?.bounds.height
			//			return height!
			return 115.0
		} else if indexPath.section == 2 || indexPath.section == 3 {
			return 115.0
		} else {
			let post = posts[indexPath.row]
			if post.image != nil {
				return 308.0
			}
			return 221.0
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			// HEADER PART
			let cell = tableView.dequeueReusableCellWithIdentifier("profileHeaderCell", forIndexPath: indexPath) as! ProfileHeaderTableViewCell
			cell.editButton?.hidden = true
			cell.tagsLabel?.text = ""
			
			cell.likeButton?.addTarget(self, action: #selector(self.likeButtonPressed(_:)), forControlEvents: .TouchUpInside)
			cell.messageButton?.addTarget(self, action: #selector(self.messageButtonPressed(_:)), forControlEvents: .TouchUpInside)
			cell.followButton?.addTarget(self, action: #selector(self.followButtonPressed(_:)), forControlEvents: .TouchUpInside)
			
			if let name = fullProfileData["name"] {
				cell.nameLabel?.text = name as? String
			}
			
			if let location = fullProfileData["location"] {
				cell.locationLabel?.text = location as? String
			}
			
			if let position = fullProfileData["occupation"] {
				cell.positionLabel?.text = position as? String
			}
			
			if let status = fullProfileData["status"] {
				cell.statusLabel?.hidden = false
				cell.statusLabel?.text = status as? String
			} else {
				cell.statusLabel?.hidden = true
			}
			
			if let description = fullProfileData["about"] {
				cell.descriptionLabel?.text = description as? String
			}
			
			if let likers = fullProfileData["likers"] as? [[String: AnyObject]] {
				cell.likeLabel?.text = String(likers.count)
			}
			
			if let isLikedByMe = fullProfileData["isLikedByMe"] as? Int {
				if isLikedByMe == 1 {
					cell.likeButton?.selected = true
				} else {
					cell.likeButton?.selected = false
				}
			}
			
			if let followers = fullProfileData["followers"] as? [[String: AnyObject]] {
				cell.followersLabel?.text = String(followers.count)
			}
			
			if let isFollowedByMe = fullProfileData["isFollowedByMe"] as? Int {
				if isFollowedByMe == 1 {
					cell.followButton?.selected = true
				} else {
					cell.followButton?.selected = false
				}
			}
			
			if let sex = fullProfileData["sex"] {
				if !sex.isEqual("U") {
					cell.nameLabel?.text = (cell.nameLabel?.text)! + ", " + (sex as? String)!
				}
			}
			
			if let url = fullProfileData["avatar"] {
				let urlString = url as? String
				if urlString != nil {
					Alamofire.request(.GET, (url as! String))
						.responseImage { response in
							if let image = response.result.value {
								cell.profileImageView!.image = image
							}
					}
				}
			}
			
			return cell
		} else if indexPath.section == 1 {
			// SKILLS/INTERESTS
			let cell = tableView.dequeueReusableCellWithIdentifier("interestsCell", forIndexPath: indexPath) as! InterestsTableViewCell
			cell.editButton?.hidden = true
			
			cell.tagListView?.removeAllTags()
			
			for interest in interestsData {
				cell.tagListView?.addTag(interest)
			}
			
			return cell
		} else if indexPath.section == 2 {
			// EDUCATION
			let cell = tableView.dequeueReusableCellWithIdentifier("educationExperienceCell", forIndexPath: indexPath) as! EducationExperienceTableViewCell
			print("COUNT:\(educationData.count)")
			cell.profileImageView?.image = UIImage(named: "education-placeholder.png")
			
			if educationData.count == 0 && indexPath.row == 0 && fullProfileData["education"] == nil  {
				cell.companyNameLabel?.text = "Add past education"
				cell.periodLabel?.text = ""
			} else if educationData.count > 0 && educationData.count == indexPath.row {
				cell.companyNameLabel?.text = "Add past education"
				cell.periodLabel?.text = ""
			} else {
				//				educationData = fullProfileData["education"] as! [[String: String]]
				cell.companyNameLabel?.text = educationData[indexPath.row]["name"]
				cell.periodLabel?.text = educationData[indexPath.row]["start"]! + " - " + educationData[indexPath.row]["finish"]!
			}
			
			return cell
		} else if indexPath.section == 3 {
			// EXPERIENCE
			let cell = tableView.dequeueReusableCellWithIdentifier("educationExperienceCell", forIndexPath: indexPath) as! EducationExperienceTableViewCell
			cell.profileImageView?.image = UIImage(named: "experience-placeholder.png")
			
			if experienceData.count == 0 && indexPath.row == experienceData.count && fullProfileData["experience"] == nil {
				cell.companyNameLabel?.text = "Add past experience"
				cell.periodLabel?.text = ""
			} else if experienceData.count != 0 && experienceData.count == indexPath.row {
				cell.companyNameLabel?.text = "Add past experience"
				cell.periodLabel?.text = ""
			} else {
				//				experienceData = fullProfileData["experience"] as! [[String: String]]
				cell.companyNameLabel?.text = experienceData[indexPath.row]["name"]
				cell.periodLabel?.text = experienceData[indexPath.row]["start"]! + " - " + experienceData[indexPath.row]["finish"]!
			}
			
			return cell
		} else {
			// POSTS
			
			let currentPost = posts[indexPath.row]
			
			if let imageURL = currentPost.image {
				let cell = tableView.dequeueReusableCellWithIdentifier("photoCardCell", forIndexPath: indexPath) as! PhotoCardTableViewCell
				
				Alamofire.request(.GET, imageURL)
					.responseImage { response in
						if let image = response.result.value {
							cell.postImage!.image = image
						}
				}
				
				if let likers = currentPost.likers {
					cell.likesLabel?.text = String(likers.count)
				}
				
				if let time = currentPost.createdTimestamp {
					cell.currentTimeLabel?.text = NewsFeedHelper.getTimeFromTimestamp(time)
				}
				
				if let name = fullProfileData["name"] {
					cell.authorLabel?.text = name as? String
				}
				
				if let position = fullProfileData["occupation"] {
					cell.authorDetailsLabel?.text = position as? String
				}
				
				if let location = fullProfileData["location"] {
					cell.authorLocationLabel?.text = location as? String
				}
				
				if let url = fullProfileData["avatar"] {
					let urlString = url as? String
					if urlString != nil {
						Alamofire.request(.GET, (url as! String))
							.responseImage { response in
								if let image = response.result.value {
									cell.profileImageView!.image = image
								}
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
			
			if let name = fullProfileData["name"] {
				cell.authorLabel?.text = name as? String
			}
			
			if let position = fullProfileData["occupation"] {
				cell.authorDetailsLabel?.text = position as? String
			}
			
			if let location = fullProfileData["location"] {
				cell.authorLocationLabel?.text = location as? String
			}
			
			if let url = fullProfileData["avatar"] {
				let urlString = url as? String
				if urlString != nil {
					Alamofire.request(.GET, (url as! String))
						.responseImage { response in
							if let image = response.result.value {
								cell.profileImageView!.image = image
							}
					}
				}
			}
			
			return cell
		}
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		if indexPath.section == 1 {
			
		} else if indexPath.section == 2 {
			performSegueWithIdentifier("editEducationSegue", sender: self)
		} else if indexPath.section == 3 {
			performSegueWithIdentifier("editExperienceSegue", sender: self)
		}
	}
	
	
	// MARK: User Interaction
	
	func likeButtonPressed(sender: UIButton) {
		if sender.selected == false {
			ProfileHelper.likeUser(userId) { (response) in
				if response == true {
					let cell = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ProfileHeaderTableViewCell
					cell.likeLabel!.text = String(Int((cell.likeLabel!.text)!)! + 1)
					cell.likeButton?.selected = true
				}
			}
		} else {
			ProfileHelper.unLikeUser(userId, completionHandler: { (response) in
				if response == true {
					let cell = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ProfileHeaderTableViewCell
					cell.likeLabel!.text = String(Int((cell.likeLabel!.text)!)! - 1)
					cell.likeButton?.selected = false
				}
			})
		}
	}
	
	func followButtonPressed(sender: UIButton) {
		if sender.selected == false {
			ProfileHelper.followUser(userId, completionHandler: { (response) in
				if response == true {
					let cell = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ProfileHeaderTableViewCell
					cell.followersLabel!.text = String(Int((cell.followersLabel!.text)!)! + 1)
					cell.followButton?.selected = true
				}
			})
		} else {
			ProfileHelper.unFollowUser(userId, completionHandler: { (response) in
				if response == true {
					let cell = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ProfileHeaderTableViewCell
					cell.followersLabel!.text = String(Int((cell.followersLabel!.text)!)! - 1)
					cell.followButton?.selected = false
				}
			})
		}
	}
	
	func messageButtonPressed(sender: UIButton) {
		performSegueWithIdentifier("showChatSegue", sender: self)
	}
	
	// MARK: Segue
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showChatSegue" {
			let destination = segue.destinationViewController as! ConversationViewController
			destination.profileId = userId
		}
	}
}
