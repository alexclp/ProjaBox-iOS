//
//  LargerTouchAreaButton.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 29/07/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class LargerTouchAreaButton: UIButton {

	override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
		let errorMargin = 30
		let largerFrame = CGRectMake(0 - CGFloat(errorMargin), 0 - CGFloat(errorMargin), self.frame.size.width + CGFloat(errorMargin), self.frame.size.height + CGFloat(errorMargin))
		if CGRectContainsPoint(largerFrame, point) == true {
			return self
		}
		return nil
	}
}
