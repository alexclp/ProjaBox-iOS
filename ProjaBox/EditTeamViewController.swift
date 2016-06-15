//
//  EditTeamViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 12/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import Eureka

class EditTeamViewController: FormViewController {

	var data = [String: String]()
	var delegate: ExperienceInputDelegate?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		setupForm()
    }
	
	func setupForm() {
		self.form +++=  TextRow("name") {
				$0.title = "Name"
				$0.placeholder = "Team member name"
			}
			
			<<< TextRow("position") {
				$0.title = "Position"
			}
			
			<<< ButtonRow() { (row: ButtonRow) -> Void in
				row.title = "Done"
				}  .onCellSelection({ (cell, row) in
					self.doneButtonPressed()
				})
	}
	
	func doneButtonPressed() {
		let values = self.form.values()
		if let name = values["name"], let position = values["position"] {
			data["name"] = name as? String
			data["position"] = position as? String
			delegate?.finishedCompletingItem(data)
			self.navigationController?.popViewControllerAnimated(true)
		} else {
			let alert = UIAlertController(title: "Alert", message: "Enter an interest please", preferredStyle: UIAlertControllerStyle.Alert)
			alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
			self.presentViewController(alert, animated: true, completion: nil)
		}

	}
}
