//
//  PostDetailsTableViewCell.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 30/04/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class PostDetailsTableViewCell: UITableViewCell {
	
	@IBOutlet weak var profileImageView: UIImageView?
	@IBOutlet weak var nameLabel: UILabel?
	@IBOutlet weak var locationLabel: UILabel?
	@IBOutlet weak var contentLabel: UILabel?
	@IBOutlet weak var likeButton: UIButton?
	@IBOutlet weak var likesLabel: UILabel?
	@IBOutlet weak var shareButton: UIButton?
	@IBOutlet weak var commentsButton: UIButton?
	@IBOutlet weak var moreButton: UIButton?
	@IBOutlet weak var timeLabel: UILabel?
	
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
		setupButtons()
	}
	
	private func imageSetup() {
		profileImageView?.layer.cornerRadius = (profileImageView?.frame.size.width)!/2
		profileImageView?.clipsToBounds = true
		profileImageView?.contentMode = .ScaleAspectFit
		profileImageView?.backgroundColor = UIColor.whiteColor()
	}
	
	private func setupButtons() {
		likeButton?.setBackgroundImage(UIImage(named: "like default.png"), forState: .Normal)
		likeButton?.setBackgroundImage(UIImage(named: "like selected.png"), forState: .Highlighted)
		likeButton?.setBackgroundImage(UIImage(named: "like selected.png"), forState: .Selected)
	}
	
}
