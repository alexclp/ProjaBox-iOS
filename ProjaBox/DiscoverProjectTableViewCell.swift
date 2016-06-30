//
//  DiscoverProjectTableViewCell.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 16/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import TagListView

class DiscoverProjectTableViewCell: UITableViewCell {
	
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var typeLabel: PillLabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var jobsTagListView: TagListView!
	@IBOutlet weak var likeButton: UIButton!
	@IBOutlet weak var likesLabel: UILabel!
	@IBOutlet weak var messageButton: UIButton!
	@IBOutlet weak var moreButton: UIButton!
	@IBOutlet weak var followButton: UIButton!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	override func layoutSubviews() {
		setupButtons()
		setupImageView()
	}
	
	private func setupImageView() {
		profileImageView?.layer.cornerRadius = (profileImageView?.frame.size.width)!/2
		profileImageView?.clipsToBounds = true
		profileImageView?.contentMode = .ScaleAspectFit
		profileImageView?.backgroundColor = UIColor.whiteColor()
	}
	
	private func setupButtons() {
		likeButton?.setBackgroundImage(UIImage(named: "like default.png"), forState: .Normal)
		likeButton?.setBackgroundImage(UIImage(named: "like selected.png"), forState: .Highlighted)
		likeButton?.setBackgroundImage(UIImage(named: "like selected.png"), forState: .Selected)
		
		moreButton?.setBackgroundImage(UIImage(named: "other default.png"), forState: .Normal)
		moreButton?.setBackgroundImage(UIImage(named: "other selected.png"), forState: .Highlighted)
		moreButton?.setBackgroundImage(UIImage(named: "other selected.png"), forState: .Selected)
	}
	
}
