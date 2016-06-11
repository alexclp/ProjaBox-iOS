//
//  PhotosTableViewCell.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 11/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {

	@IBOutlet weak var photosCollectionView: UICollectionView?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
