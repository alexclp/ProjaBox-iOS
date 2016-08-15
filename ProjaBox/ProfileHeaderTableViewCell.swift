//
//  ProfileHeaderTableViewCell.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 25/05/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class ProfileHeaderTableViewCell: UITableViewCell {
	
	@IBOutlet weak var profileImageView: UIImageView?
	@IBOutlet weak var nameLabel: UILabel?
	@IBOutlet weak var locationLabel: UILabel?
	@IBOutlet weak var positionLabel: UILabel?
	@IBOutlet weak var projectTypeLabel: PillLabel?
	@IBOutlet weak var statusLabel: PillLabel?
	@IBOutlet weak var tagsLabel: UILabel?
	@IBOutlet weak var descriptionLabel: UILabel?
	@IBOutlet weak var likeButton: UIButton?
	@IBOutlet weak var likeLabel: UILabel?
	@IBOutlet weak var messageButton: UIButton?
	@IBOutlet weak var moreButton: UIButton?
	@IBOutlet weak var followButton: UIButton?
	@IBOutlet weak var followersLabel: UILabel?
	@IBOutlet weak var editButton: UIButton?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	override func layoutSubviews() {
		imageSetup()
		buttonsSetup()
	}
	
	func buttonsSetup() {
		likeButton?.imageView?.contentMode = .ScaleAspectFit
		followButton?.imageView?.contentMode = .ScaleAspectFit
		moreButton?.imageView?.contentMode = .ScaleAspectFit
		
		likeButton?.setImage(UIImage(named: "like default.png"), forState: .Normal)
		likeButton?.setImage(UIImage(named: "like selected.png"), forState: .Highlighted)
		likeButton?.setImage(UIImage(named: "like selected.png"), forState: .Selected)
		
		moreButton?.setImage(UIImage(named: "other default.png"), forState: .Normal)
		moreButton?.setImage(UIImage(named: "other selected.png"), forState: .Highlighted)
		moreButton?.setImage(UIImage(named: "other selected.png"), forState: .Selected)
		
		followButton?.setImage(UIImage(named: "follow.png"), forState: .Normal)
		followButton?.setImage(UIImage(named: "follow_selected.png"), forState: .Highlighted)
		followButton?.setImage(UIImage(named: "follow_selected.png"), forState: .Selected)
	}
	
	func imageSetup() {
		profileImageView?.layer.cornerRadius = (profileImageView?.frame.size.width)!/2
		profileImageView?.clipsToBounds = true
		profileImageView?.contentMode = .ScaleAspectFit
		profileImageView?.backgroundColor = UIColor.whiteColor()
	}
	
}
