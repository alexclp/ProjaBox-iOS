//
//  Post.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 06/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class UserPost: NSObject {
	var content: String?
	var createdTimestamp: Int?
	var id: Int?
	var isLikedByMe: Bool?
	var name: String?
	var ownerId: Int?
	var image: NSData?
	var video: NSData?
}
