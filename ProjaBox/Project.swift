//
//  Project.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 16/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class Project: NSObject {
	var id: Int?
	var desc: String?
	var name: String?
	var location: String?
	var jobs: [String]?
	var isLikedByMe: Bool?
	var type: String?
	var likers: [[String: AnyObject]]?
	var isFollowed: Bool?
}
