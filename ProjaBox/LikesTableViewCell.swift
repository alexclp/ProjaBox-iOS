//
//  LikesTableViewCell.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 30/04/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class LikesTableViewCell: UITableViewCell {

	@IBOutlet weak var profileImageView1: UIImageView?
	@IBOutlet weak var profileImageView2: UIImageView?
	@IBOutlet weak var profileImageView3: UIImageView?
	@IBOutlet weak var profileImageView4: UIImageView?
	@IBOutlet weak var profileImageView5: UIImageView?
	@IBOutlet weak var profileImageView6: UIImageView?
	@IBOutlet weak var profileImageView7: UIImageView?
	
	var imageViewList: [UIImageView] {
		get {
			return [profileImageView1!, profileImageView2!, profileImageView3!, profileImageView4!, profileImageView5!, profileImageView6!, profileImageView7!]
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	override func layoutSubviews() {
		makeImageViewsRound()
	}
	
	func makeImageViewsRound() {
		for image in imageViewList {
			image.layer.cornerRadius = (image.frame.size.width)/2
			image.clipsToBounds = true
			image.contentMode = .ScaleAspectFit
			image.backgroundColor = UIColor.whiteColor()
		}
	}
	
}
