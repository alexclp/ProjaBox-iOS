//
//  User.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 16/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class User: NSObject {
	var id: Int?
	var name: String?
	var location: String?
	var likers: [[String: AnyObject]]?
	var about: String?
	var status: String?
	var isFollowed: Int?
	var isLikedByMe: Int?
	var avatar: String?
	var position: String?
}
