//
//  PhotoCardTableViewCell.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 28/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class PhotoCardTableViewCell: UITableViewCell {

	@IBOutlet weak var authorLabel: UILabel?
	@IBOutlet weak var authorDetailsLabel: UILabel?
	@IBOutlet weak var authorLocationLabel: UILabel?
	@IBOutlet weak var currentTimeLabel: UILabel?
	@IBOutlet weak var postImage: UIImageView?
	@IBOutlet weak var profileImageView: UIImageView?
	@IBOutlet weak var locationImageView: UIImageView?
	@IBOutlet weak var cardView: UIView?
	@IBOutlet weak var likeButton: UIButton?
	@IBOutlet weak var shareButton: UIButton?
	@IBOutlet weak var commentButton: UIButton?
	@IBOutlet weak var moreButton: UIButton?
	@IBOutlet weak var likesLabel: UILabel?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
