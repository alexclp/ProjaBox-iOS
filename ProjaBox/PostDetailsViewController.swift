//
//  PostDetailsViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 28/04/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class PostDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var postDetailsTableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		postDetailsTableView!.registerNib(UINib(nibName: "PostDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "postDetailsCell")
		postDetailsTableView!.registerNib(UINib(nibName: "LikesTableViewCell", bundle: nil), forCellReuseIdentifier: "likesCell")
		postDetailsTableView!.registerNib(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "commentCell")
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
		return 2 + 4
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		if indexPath.row == 0 {
			
			let cell = tableView.dequeueReusableCellWithIdentifier("postDetailsCell", forIndexPath: indexPath) as! PostDetailsTableViewCell
			cell.selectionStyle = .None
			
			cell.likeButton?.addTarget(self, action: #selector(PostDetailsViewController.likePressed(_:)), forControlEvents: .TouchUpInside)
			cell.shareButton?.addTarget(self, action: #selector(PostDetailsViewController.sharePressed(_:)), forControlEvents: .TouchUpInside)
			cell.commentsButton?.addTarget(self, action: #selector(PostDetailsViewController.commentPressed(_:)), forControlEvents: .TouchUpInside)
			cell.moreButton?.addTarget(self, action: #selector(PostDetailsViewController.morePressed(_:)), forControlEvents: .TouchUpInside)
			
			cell.profileImageView?.image = UIImage(named: "telegram.png")
			
			return cell
			
		} else if indexPath.row == 1 {
			
			let cell = tableView.dequeueReusableCellWithIdentifier("likesCell", forIndexPath: indexPath) as! LikesTableViewCell
			cell.profileImageView1?.hidden = false
			cell.profileImageView1?.image = UIImage(named: "profile_pic.jpg")
			cell.selectionStyle = .Gray
			
			return cell
			
		}
		
		let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentTableViewCell
		cell.selectionStyle = .None
		cell.profileImageView?.image = UIImage(named: "telegram.png")
		
		return cell
	}
//	
//	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//		if section == 0 {
//			return 6.0
//		}
//		
//		return CGFloat.min
//	}
//	
//	func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//		return 5.0
//	}
//	
//	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//		return UIView.init(frame: CGRectZero)
//	}
//	
//	func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//		return UIView.init(frame: CGRectZero)
//	}
	
	// MARK: Table View Delegate
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
	// MARK: User Interaction
	
	func likePressed(sender: UIButton) {
		
	}
	
	func sharePressed(sender: UIButton) {
		
	}
	
	func commentPressed(sender: UIButton) {
		
	}
	
	func morePressed(sender: UIButton) {
		
	}
}
