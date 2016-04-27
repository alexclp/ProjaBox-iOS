
//
//  CreatingPostViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 26/04/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class CreatingPostViewController: UIViewController {

	@IBOutlet weak var textView: UITextView?
	@IBOutlet weak var profileImageView: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		addToolBar(textView!)
		setupImageView()
    }
	
	func setupImageView() {
		profileImageView?.layer.cornerRadius = (profileImageView?.frame.size.width)!/2
		profileImageView?.clipsToBounds = true
		profileImageView?.contentMode = .ScaleAspectFit
		profileImageView?.backgroundColor = UIColor.whiteColor()
	}
	
	@IBAction func doneButtonPressed() {
		dismissViewControllerAnimated(true, completion: nil)
	}

}

extension UIViewController: UITextViewDelegate {
	
	func addToolBar(textView: UITextView) {
		let toolBar = UIToolbar()
		toolBar.barStyle = UIBarStyle.Default
		toolBar.translucent = true
		toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
		let globeButton = UIBarButtonItem(title: "Globe", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UIViewController.globePressed))
		let urlButton = UIBarButtonItem(title: "URL", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UIViewController.urlPressed))
		let photoButton = UIBarButtonItem(title: "Photo", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UIViewController.photoPressed))
		let postButton = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.Done, target: self, action: #selector(UIViewController.postPressed))
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
		toolBar.setItems([globeButton, spaceButton, urlButton, spaceButton, photoButton, spaceButton, postButton], animated: false)
		toolBar.userInteractionEnabled = true
		toolBar.sizeToFit()
		
		textView.delegate = self
		textView.inputAccessoryView = toolBar
	}
	
	func postPressed() {
		view.endEditing(true)
	}
	
	func urlPressed() {
		view.endEditing(true)
	}
	
	func globePressed() {
		view.endEditing(true)
	}
	
	func photoPressed() {
		view.endEditing(true)
	}
}
