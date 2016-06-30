//
//  ProfileViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 27/03/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

import AlamofireImage
import Alamofire

class MyProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ExperienceInputDelegate, InterestsInputDelegate, BioDataDelegate {
	
	@IBOutlet weak var tableView: UITableView?
	
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
		
		self.title = "My profile"
		
		ProfileHelper.getMyFullProfile { (response, data) in
			if response == true {
				self.fullProfileData = data!
				self.getLatestPosts()
			} else {
				
			}
		}
	}
	
	func fillData() {
		if let education = fullProfileData["education"] {
			educationData = education as! [[String : String]]
		}
		
		if let experience = fullProfileData["experience"] {
			experienceData = experience as! [[String : String]]
		}
		
		if let interests = fullProfileData["interests"] {
			interestsData = interests as! [String]
		}
		
		// bio
		
		if let name = fullProfileData["name"] {
			bioData["name"] = name as! String
		}
		
		if let location = fullProfileData["location"] {
			bioData["location"] = location as! String
		}
		
		if let position = fullProfileData["occupation"] {
			bioData["occupation"] = position as! String
		}
		
		if let status = fullProfileData["status"] {
			bioData["status"] = status as! String
		}
		
		if let about = fullProfileData["about"] {
			bioData["about"] = about
		}
		
		if let sex = fullProfileData["sex"] {
			if !sex.isEqual("U") {
				bioData["sex"] = sex
			}
		}
		
		tableView?.reloadData()
	}
	
	func getLatestPosts() {
		ProfileHelper.getUsersLatestPosts(String(fullProfileData["id"]!)) { (response, posts) in
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
			return educationData.count + 1
		} else if section == 3 {
			return experienceData.count + 1
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
			cell.editButton?.addTarget(self, action: #selector(self.editBioPressed(_:)), forControlEvents: .TouchUpInside)
			cell.tagsLabel?.text = ""
			
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
			
			if let sex = fullProfileData["sex"] {
				if !sex.isEqual("U") {
					cell.nameLabel?.text = (cell.nameLabel?.text)! + ", " + (sex as? String)!
				}
			}
			
			if ((fullProfileData["avatar"]?.isEqual(NSNull)) != nil) {
				if let url = fullProfileData["avatar"] {
					Alamofire.request(.GET, (url as! String))
						.responseImage { response in
							if let image = response.result.value {
								print("image downloaded: \(image)")
								cell.profileImageView!.image = image
							}
					}
				}
			}
	
			return cell
		} else if indexPath.section == 1 {
			// SKILLS/INTERESTS
			let cell = tableView.dequeueReusableCellWithIdentifier("interestsCell", forIndexPath: indexPath) as! InterestsTableViewCell
			cell.editButton?.addTarget(self, action: #selector(self.editInterestsButtonPressed(_:)), forControlEvents: .TouchUpInside)
			
			for interest in interestsData {
				cell.tagListView?.addTag(interest)
			}
			
			return cell
		} else if indexPath.section == 2 {
			// EDUCATION
			let cell = tableView.dequeueReusableCellWithIdentifier("educationExperienceCell", forIndexPath: indexPath) as! EducationExperienceTableViewCell
			
			if educationData.count == 0 || indexPath.row == educationData.count {
				cell.companyNameLabel?.text = "Add past education"
			} else {
				cell.companyNameLabel?.text = educationData[indexPath.row]["name"]
				cell.periodLabel?.text = educationData[indexPath.row]["start"]! + " - " + educationData[indexPath.row]["finish"]!
			}
			
			return cell
		} else if indexPath.section == 3 {
			// EXPERIENCE
			let cell = tableView.dequeueReusableCellWithIdentifier("educationExperienceCell", forIndexPath: indexPath) as! EducationExperienceTableViewCell
			
			if experienceData.count == 0 || indexPath.row == experienceData.count {
				cell.companyNameLabel?.text = "Add past experience"
			} else {
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
				
				if let name = fullProfileData["name"] {
					cell.authorLabel?.text = name as? String
				}
				
				if let position = fullProfileData["occupation"] {
					cell.authorDetailsLabel?.text = position as? String
				}
				
				if let location = fullProfileData["location"] {
					cell.authorLocationLabel?.text = location as? String
				}
				
				if ((fullProfileData["avatar"]?.isEqual(NSNull)) != nil) {
					if let url = fullProfileData["avatar"] {
						Alamofire.request(.GET, (url as! String))
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
			
			if ((fullProfileData["avatar"]?.isEqual(NSNull)) != nil) {
				if let url = fullProfileData["avatar"] {
					Alamofire.request(.GET, (url as! String))
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
	
	// MARK: Segue
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "editEducationSegue" {
			let destination = segue.destinationViewController as! EditEducationViewController
			destination.delegate = self
		} else if segue.identifier == "editExperienceSegue" {
			let destination = segue.destinationViewController as! EditExperienceViewController
			destination.delegate = self
		} else if segue.identifier == "editInterestsSegue" {
			let destination = segue.destinationViewController as! EditInterestsViewController
			destination.interestsList = interestsData
			destination.delegate = self
		} else if segue.identifier == "editBioSegue" {
			let destination = segue.destinationViewController as! EditBioViewController
			destination.formData = bioData
			destination.delegate = self
		}
 	}
	
	// MARK: User interaction
	
	func editBioPressed(sender: UIButton) {
		performSegueWithIdentifier("editBioSegue", sender: self)
	}
	
	func editInterestsButtonPressed(sender: UIButton) {
		performSegueWithIdentifier("editInterestsSegue", sender: self)
	}
	
	// MARK: Finished entering data delegate
	
	func finishedCompletingItem(item: [String : String]) {
		if let university = item["university"] {
			// Education item
			var data = item
			data.removeValueForKey("university")
			data["name"] = university
			educationData.append(data)
			fullProfileData["education"] = educationData
			updateProfile()
			tableView?.reloadData()
		} else if let work = item["work"] {
			// Work item
			var data = item
			data.removeValueForKey("work")
			data["work"] = work
			experienceData.append(data)
			fullProfileData["experience"] = experienceData
			updateProfile()
			tableView?.reloadData()
		}
	}
	
	func userDidFinishEditingInterests(interests: [String]) {
		interestsData = interests
		fullProfileData["interests"] = interestsData
		tableView?.reloadData()
		updateProfile()
	}
	
	func userDidFinishCompletingData(bioData: [String : AnyObject]) {
		self.bioData = bioData
		unwrapBioData()
//		tableView?.reloadData()
		updateProfile()
	}
	
	func unwrapBioData() {
		fullProfileData["name"] = bioData["name"]
		fullProfileData["location"] = bioData["location"]
		fullProfileData["occupation"] = bioData["occupation"]
		fullProfileData["status"] = bioData["status"]
		fullProfileData["about"] = bioData["about"]
		fullProfileData["sex"] = bioData["sex"]
		fullProfileData["avatar"] = bioData["avatar"]
	}
	
	// MARK: UPDATING
	
	func updateProfile() {
		ProfileHelper.updateMyProfile(fullProfileData) { (response, data) in
			if response != true {
				print("Update failed")
			} else {
				print("Update successful")
				if let data = data {
					self.fullProfileData = data
					self.tableView?.reloadData()
				}
			}
		}
	}
}