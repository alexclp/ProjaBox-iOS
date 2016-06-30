//
//  ChatListTableViewCell.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 23/04/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {
	
	@IBOutlet weak var profileImageView: UIImageView?
	@IBOutlet weak var timeLabel: UILabel?
	@IBOutlet weak var nameLabel: UILabel?
	@IBOutlet weak var previewLabel: UILabel?
	
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
