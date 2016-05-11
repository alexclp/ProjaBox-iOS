//
//  SettingsTableViewCell.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 11/05/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

	@IBOutlet weak var cellImageView: UIImageView?
	@IBOutlet weak var cellTitleLabel: UILabel?
	@IBOutlet weak var cellAccessoryImageView: UIImageView?
	
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
		cellImageView?.layer.cornerRadius = (cellImageView?.frame.size.width)!/2
		cellImageView?.clipsToBounds = true
		cellImageView?.contentMode = .ScaleAspectFit
		cellImageView?.backgroundColor = UIColor.whiteColor()
		
		cellAccessoryImageView?.layer.cornerRadius = (cellAccessoryImageView?.frame.size.width)!/2
		cellAccessoryImageView?.clipsToBounds = true
		cellAccessoryImageView?.contentMode = .ScaleAspectFit
		cellAccessoryImageView?.backgroundColor = UIColor.whiteColor()
	}

}
