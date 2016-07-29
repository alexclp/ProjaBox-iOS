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
	@IBOutlet weak var typeLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var jobsTagListView: TagListView!
	@IBOutlet weak var likeButton: LargerTouchAreaButton!
	@IBOutlet weak var likesLabel: UILabel!
	@IBOutlet weak var messageButton: LargerTouchAreaButton!
	@IBOutlet weak var moreButton: LargerTouchAreaButton!
	@IBOutlet weak var followButton: LargerTouchAreaButton!
	
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
		setupLabel()
	}
	
	private func setupImageView() {
		profileImageView?.layer.cornerRadius = (profileImageView?.frame.size.width)!/2
		profileImageView?.clipsToBounds = true
		profileImageView?.contentMode = .ScaleAspectFit
		profileImageView?.backgroundColor = UIColor.whiteColor()
	}
	
	private func setupLabel() {
		typeLabel.layer.backgroundColor = UIColor.whiteColor().CGColor
		typeLabel.textColor = UIColor.blackColor()
		typeLabel.layer.cornerRadius = 5
		typeLabel.layer.borderColor = UIColor.lightGrayColor().CGColor
		typeLabel.layer.borderWidth = 0.5
	}
	
	private func setupButtons() {
		likeButton?.setImage(UIImage(named: "like default.png"), forState: .Normal)
		likeButton?.setImage(UIImage(named: "like selected.png"), forState: .Highlighted)
		likeButton?.setImage(UIImage(named: "like selected.png"), forState: .Selected)
		
		moreButton?.setImage(UIImage(named: "other default.png"), forState: .Normal)
		moreButton?.setImage(UIImage(named: "other selected.png"), forState: .Highlighted)
		moreButton?.setImage(UIImage(named: "other selected.png"), forState: .Selected)
	}
	
}
