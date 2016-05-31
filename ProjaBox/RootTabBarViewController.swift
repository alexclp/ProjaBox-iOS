//
//  RootTabBarViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 27/05/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class RootTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		print("items: \(self.tabBar.items?.count)")
		
//		self.tabBar.barTintColor = UIColor.blueColor()
		
		let image = UIImage(named: "tab-bar-background.png")?.imageWithRenderingMode(.AlwaysOriginal)
		
//		self.tabBar.items![0].selectedImage = image
//		self.tabBar.backgroundImage = image
    }
}
