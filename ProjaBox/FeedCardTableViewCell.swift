//
//  FeedCardTableViewCell.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 19/04/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class FeedCardTableViewCell: UITableViewCell {
	
	@IBOutlet weak var authorLabel: UILabel?
	@IBOutlet weak var authorDetailsLabel: UILabel?
	@IBOutlet weak var authorLocationLabel: UILabel?
	@IBOutlet weak var currentTimeLabel: UILabel?
	@IBOutlet weak var postLabel: UILabel?
	@IBOutlet weak var profileImageView: UIImageView?
	@IBOutlet weak var locationImageView: UIImageView?
	@IBOutlet weak var cardView: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	override func layoutSubviews() {
		cardSetup()
		imageSetup()
	}
	
	func cardSetup() {
		cardView?.alpha = 1
		cardView?.layer.masksToBounds = false
		cardView?.layer.cornerRadius = 1 // if you like rounded corners
		cardView?.layer.shadowOffset = CGSizeMake(-0.2, 0.2) //%%% this shadow will hang slightly down and to the right
		cardView?.layer.shadowRadius = 1 //%%% I prefer thinner, subtler shadows, but you can play with this
		cardView?.layer.shadowOpacity = 0.2 //%%% same thing with this, subtle is better for me
		
		//%%% This is a little hard to explain, but basically, it lowers the performance required to build shadows.  If you don't use this, it will lag
		
		let path = UIBezierPath(rect: cardView!.bounds)
		cardView!.layer.shadowPath = path.CGPath
	}
	
	func imageSetup() {
		profileImageView?.layer.cornerRadius = (profileImageView?.frame.size.width)!/2
		profileImageView?.clipsToBounds = true
		profileImageView?.contentMode = .ScaleAspectFit
		profileImageView?.backgroundColor = UIColor.whiteColor()
	}

}
