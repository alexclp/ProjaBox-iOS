//
//  EditGoalsViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 12/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class EditGoalsViewController: UIViewController {

	@IBOutlet weak var textView: UITextView?
	
	var goals = String()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
    }
	
	@IBAction func doneButtonPressed() {
		// save/send the data
		
		if let text = textView?.text {
			goals = text
			// TODO: some delegate call here
			self.navigationController?.popViewControllerAnimated(true)
		}
	}
}
