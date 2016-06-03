//
//  NoAnimationSegue.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 03/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class NoAnimationSegue: UIStoryboardSegue {

	override func perform() {
		let source = self.sourceViewController
		let destination = self.destinationViewController
		
		source.navigationController?.pushViewController(destination, animated: false)
	}
	
}
