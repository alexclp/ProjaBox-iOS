//
//  SharingHelper.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 08/04/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class SharingHelper {
//	TODO: Static method for sharing stuff
	
	class func shareProjectOrPerson(url: String) -> UIActivityViewController? {
		let textToShare = "Project Default text"
		let imageToShare = UIImage()
		
		if let postURL = NSURL(string: url) {
			let objectsToShare = [textToShare, imageToShare, postURL]
			let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
			activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
			return activityVC
		}
		return nil
	}
	
}
