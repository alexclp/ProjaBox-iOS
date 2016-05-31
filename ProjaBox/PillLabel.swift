//
//  PillLabel.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 31/05/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class PillLabel : UILabel{
	
	@IBInspectable var color = UIColor.lightGrayColor()
	@IBInspectable var cornerRadius: CGFloat = 8
	@IBInspectable var labelText: String = "None"
	@IBInspectable var fontSize: CGFloat = 10.5
	
	// This has to be balanced with the number of spaces prefixed to the text
	let borderWidth: CGFloat = 3
	
	init(text: String, color: UIColor = UIColor.lightGrayColor()) {
		super.init(frame: CGRectMake(0, 0, 1, 1))
		labelText = text
		self.color = color
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	func setup(){
		// This has to be balanced with the borderWidth property
		text = "  \(labelText)".uppercaseString
		
		// Credits to http://stackoverflow.com/a/33015915/784318
		layer.borderWidth = borderWidth
		layer.cornerRadius = cornerRadius
		backgroundColor = color
		layer.borderColor = color.CGColor
		layer.masksToBounds = true
		font = UIFont.boldSystemFontOfSize(fontSize)
		textColor = color.contrastColor
		sizeToFit()
		
		// Credits to http://stackoverflow.com/a/15184257/784318
		frame = CGRectInset(self.frame, -borderWidth, -borderWidth)
	}
}


extension UIColor {
	// Credits to http://stackoverflow.com/a/29044899/784318
	func isLight() -> Bool{
		var green: CGFloat = 0.0, red: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
		self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		let brightness = ((red * 299) + (green * 587) + (blue * 114) ) / 1000
		
		return brightness < 0.5 ? false : true
	}
	
	var contrastColor: UIColor{
		return self.isLight() ? UIColor.blackColor() : UIColor.whiteColor()
	}
}
