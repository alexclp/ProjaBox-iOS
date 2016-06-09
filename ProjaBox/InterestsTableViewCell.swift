//
//  InterestsTableViewCell.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 01/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import TagListView

class InterestsTableViewCell: UITableViewCell {

	@IBOutlet weak var tagListView: TagListView?
	@IBOutlet weak var editButton: UIButton?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
