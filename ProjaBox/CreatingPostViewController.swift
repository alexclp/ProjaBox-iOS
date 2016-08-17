
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
	
	let placeholderText = "Write something or use @ to mention someone"
	
	@IBOutlet weak var textView: UITextView?
	@IBOutlet weak var profileImageView: UIImageView!
	
	var projectPost = Bool()
	var projectId = String()
	var isEditingPost = false
	var editedUserPost = UserPost()
	var editedProjectPost = ProjectPost()
	
	// TODO: Add UI Elements to keyboard toolbar
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		addToolBar(textView!)
		setupImageView()
		
		textView!.text = placeholderText
		textView!.textColor = UIColor.lightGrayColor()
		
		textView!.becomeFirstResponder()
		
		textView!.selectedTextRange = textView!.textRangeFromPosition(textView!.beginningOfDocument, toPosition: textView!.beginningOfDocument)
		
		if editedProjectPost.id != nil {
			textView?.text = editedProjectPost.content
			textView?.textColor = UIColor.blackColor()
			projectPost = true
		} else if editedUserPost.id != nil {
			textView?.text = editedUserPost.content
			textView?.textColor = UIColor.blackColor()
		}
	}
	
	func setupImageView() {
		profileImageView?.layer.cornerRadius = (profileImageView?.frame.size.width)!/2
		profileImageView?.clipsToBounds = true
		profileImageView?.contentMode = .ScaleAspectFit
		profileImageView?.backgroundColor = UIColor.whiteColor()
	}
	
	@IBAction func doneButtonPressed() {
		var textToShare = textView?.text
		if isEditingPost == true {
			if projectPost == true {
				let projectId = String(editedProjectPost.projectId!)
				let postId = String(editedProjectPost.id!)
				ProjectHelper.editPost(projectId, postId: postId, content: ["content": textToShare!], completionHandler: { (response) in
					self.isEditingPost = false
				})
			} else {
				let postId = String(editedUserPost.id!)
				NewsFeedHelper.editPost(postId, content: ["content": textToShare!], completionHandler: { (response) in
					self.isEditingPost = false
				})
			}
		} else {
			if projectPost == true {
				if textToShare == placeholderText {
					textToShare = ""
				}
				ProjectHelper.createPost(projectId, "Post", textToShare!, nil, nil, completionHandler: { (response) in
					if response  == false {
						let alert = UIAlertController(title: "Alert", message: "There was an error while creating the post. Please try again later.", preferredStyle: UIAlertControllerStyle.Alert)
						alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
						self.presentViewController(alert, animated: true, completion: nil)
					}
				})
			} else {
				if textToShare == placeholderText {
					textToShare = ""
				}
				NewsFeedHelper.createTextPost("Post", textToShare!) { (response) in
					if response == false {
						let alert = UIAlertController(title: "Alert", message: "There was an error while creating the post. Please try again later.", preferredStyle: UIAlertControllerStyle.Alert)
						alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
						self.presentViewController(alert, animated: true, completion: nil)
					}
				}
			}
		}
		self.navigationController?.popViewControllerAnimated(true)
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	// MARK: Text View Delegate
	
	func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
		
		// Combine the textView text and the replacement text to
		// create the updated text string
		let currentText: NSString = textView.text
		let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
		
		// If updated text view will be empty, add the placeholder
		// and set the cursor to the beginning of the text view
		if updatedText.isEmpty {
			
			textView.text = placeholderText
			textView.textColor = UIColor.lightGrayColor()
			
			textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
			
			return false
			
		} else if textView.textColor == UIColor.lightGrayColor() && !text.isEmpty {
			textView.text = nil
			textView.textColor = UIColor.blackColor()
		}
		
		// Else if the text view's placeholder is showing and the
		// length of the replacement string is greater than 0, clear
		// the text view and set its color to black to prepare for
		// the user's entry
		
		return true
	}
	
	func textViewDidChangeSelection(textView: UITextView) {
		if self.view.window != nil {
			if textView.textColor == UIColor.lightGrayColor() {
				textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
			}
		}
	}
}

extension UIViewController: UITextViewDelegate {
	
	func addToolBar(textView: UITextView) {
		let toolBar = UIToolbar()
		toolBar.barStyle = UIBarStyle.Default
		toolBar.translucent = true
		toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
		//		let globeButton = UIBarButtonItem(title: "Globe", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UIViewController.globePressed))
		let urlButton = UIBarButtonItem(title: "URL", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UIViewController.urlPressed))
		let photoButton = UIBarButtonItem(title: "Photo", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UIViewController.photoPressed))
		let postButton = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.Done, target: self, action: #selector(UIViewController.postPressed))
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
		//		toolBar.setItems([globeButton, spaceButton, urlButton, spaceButton, photoButton, spaceButton, postButton], animated: false)
		toolBar.setItems([spaceButton, urlButton, spaceButton, photoButton, spaceButton, postButton], animated: false)
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
