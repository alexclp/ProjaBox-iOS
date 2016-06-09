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
	@IBOutlet weak var statusLabel: UILabel?
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
	}
	
	func imageSetup() {
		profileImageView?.layer.cornerRadius = (profileImageView?.frame.size.width)!/2
		profileImageView?.clipsToBounds = true
		profileImageView?.contentMode = .ScaleAspectFit
		profileImageView?.backgroundColor = UIColor.whiteColor()
	}
    
}
