//
//  CommentTableViewCell.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 29/04/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
	
	@IBOutlet weak var timeLabel: UILabel?
	@IBOutlet weak var nameLabel: UILabel?
	@IBOutlet weak var positionLabel: UILabel?
	@IBOutlet weak var commentLabel: UILabel?
	@IBOutlet weak var profileImageView: UIImageView?
	
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
