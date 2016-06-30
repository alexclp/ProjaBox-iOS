
//
//  EditInterestsViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 09/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import TagListView

protocol InterestsInputDelegate {
	func userDidFinishEditingInterests(interests: [String])
}

class EditInterestsViewController: UIViewController, TagListViewDelegate {
	
	@IBOutlet weak var tagListView: TagListView?
	@IBOutlet weak var tagTextField: UITextField?
	
	var delegate: InterestsInputDelegate?
	
	var interestsList = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		self.navigationItem.hidesBackButton = true
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(self.donePressed(_:)))
		tagListView?.delegate = self
		
		fillData()
	}
	
	func fillData() {
		for interest in interestsList {
			tagListView?.addTag(interest)
		}
	}
	
	func removeTag(tag: String) {
		for i in 0..<interestsList.count {
			if interestsList[i] == tag {
				interestsList.removeAtIndex(i)
				break
			}
		}
		tagListView?.removeTag(tag)
	}
	
	func donePressed(sender: UIBarButtonItem) {
		delegate?.userDidFinishEditingInterests(interestsList)
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	@IBAction func addButtonPressed() {
		if let interest = tagTextField?.text {
			interestsList.append(interest)
			tagListView?.addTag(interest)
			tagTextField?.text = ""
		} else {
			let alert = UIAlertController(title: "Alert", message: "Enter an interest please", preferredStyle: UIAlertControllerStyle.Alert)
			alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	// MARK: Tag List Delegate
	
	func tagRemoveButtonPressed(title: String, tagView: TagView, sender: TagListView) {
		removeTag(title)
	}
}
