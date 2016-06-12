//
//  EditJobsFormViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 12/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import TagListView

class EditJobsFormViewController: UIViewController, TagListViewDelegate {
	
	// TODO: Setup in Interface Builder
	
	@IBOutlet weak var tagListView: TagListView?
	@IBOutlet weak var tagTextField: UITextField?
	
	var delegate: InterestsInputDelegate?
	
	var jobsList = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		self.navigationItem.hidesBackButton = true
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(self.donePressed(_:)))
		tagListView?.delegate = self
		
		fillData()
	}
	
	func fillData() {
		for job in jobsList {
			tagListView?.addTag(job)
		}
	}
	
	func removeTag(tag: String) {
		for i in 0..<jobsList.count {
			if jobsList[i] == tag {
				jobsList.removeAtIndex(i)
				break
			}
		}
		tagListView?.removeTag(tag)
	}
	
	func donePressed(sender: UIBarButtonItem) {
		delegate?.userDidFinishEditingInterests(jobsList)
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	@IBAction func addButtonPressed() {
		if let interest = tagTextField?.text {
			jobsList.append(interest)
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
