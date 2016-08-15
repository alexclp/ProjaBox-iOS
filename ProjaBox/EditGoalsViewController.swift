//
//  EditGoalsViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 12/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

protocol GoalsInputDelegate {
	func userFinishedEditingGoals(goals: String)
}

class EditGoalsViewController: UIViewController {
	
	@IBOutlet weak var textView: UITextView?
	
	var delegate: GoalsInputDelegate?
	
	var goals = String()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(self.backButtonPressed(_:)))
		self.textView?.text = goals
	}
	
	func backButtonPressed(sender: UIBarButtonItem) {
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	@IBAction func doneButtonPressed() {
		// save/send the data
		
		if let text = textView?.text {
			goals = text
			delegate?.userFinishedEditingGoals(goals)
			self.navigationController?.popViewControllerAnimated(true)
		}
	}
}
