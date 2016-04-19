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
		let imageToShare = UIImage(named: "testimage.jpeg")
		
		if let postURL = NSURL(string: url), let postImage = imageToShare {
			let objectsToShare: [AnyObject] = [postImage, postURL]
			let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
			activityVC.excludedActivityTypes = [UIActivityTypeAirDrop,
			                                    UIActivityTypeAddToReadingList,
			                                    UIActivityTypePrint,
			                                    UIActivityTypeOpenInIBooks,
			                                    UIActivityTypeAssignToContact,
			                                    UIActivityTypeSaveToCameraRoll,
			                                    UIActivityTypePostToVimeo,
			                                    UIActivityTypePostToFlickr,
			                                    UIActivityTypePostToWeibo]
			
			return activityVC
		}
		return nil
	}
	
}
