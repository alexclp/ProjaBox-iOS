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
		
		self.tabBarController?.navigationItem.hidesBackButton = true
		self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(self.backButtonPressed(_:)))
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
	
	func backButtonPressed(sender: UIBarButtonItem) {
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	func doneButtonPressed() {
		let values = self.form.values()
		if let name = values["name"], let position = values["position"] {
			if name != nil && position != nil {
				searchForTeammate(name as! String, completionHandler: { (response, result) in
					if response == true {
						if let userData = result {
							self.data["id"] = String(userData[0].id!)
							self.data["position"] = position as? String
							self.delegate?.finishedCompletingItem(self.data)
							self.navigationController?.popViewControllerAnimated(true)
						}
					} else {
						let alert = UIAlertController(title: "Alert", message: "No user was found with this name", preferredStyle: UIAlertControllerStyle.Alert)
						alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
						self.presentViewController(alert, animated: true, completion: nil)
					}
				})
			} else {
				let alert = UIAlertController(title: "Alert", message: "Enter all data please", preferredStyle: UIAlertControllerStyle.Alert)
				alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
				self.presentViewController(alert, animated: true, completion: nil)
			}
		}
	}
	
	func searchForTeammate(name: String, completionHandler: (Bool, [User]?) -> Void) {
		SearchHelper.searchForUsers(name) { (response, result) in
			print("result: \(result)")
			if response == true {
				completionHandler(true, result)
			} else {
				completionHandler(false, nil)
			}
		}
	}
}
