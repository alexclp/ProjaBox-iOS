//
//  EditAboutProjectViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 12/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import Eureka

class EditAboutProjectViewController: FormViewController {
	
	var data = [String: String]()
	var delegate: BioDataDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		setupForm()
	}
	
	func setupForm() {
		self.form +++=  TextRow("name") {
				$0.title = "Name"
				$0.placeholder = "Type your project name"
			}
			<<< TextRow("location") {
				$0.title = "Location"
				$0.placeholder = "Type your location"
			}
			<<< TextRow("type") {
				$0.title = "Type"
				$0.placeholder = "e.g. Tech Startup"
			}
			<<< TextRow("description") {
				$0.title = "Description"
				$0.placeholder = "Short description"
			}
			<<< ImageRow("avatar"){
				$0.title = "Picture"
			}
			<<< ButtonRow() { (row: ButtonRow) -> Void in
				row.title = "Done"
				}  .onCellSelection({ (cell, row) in
					self.doneButtonPressed()
				})
	}
	
	func doneButtonPressed() {
		let formValues = self.form.values()
		
		if let name = formValues["name"], let location = formValues["location"], let description = formValues["description"] {
//			let avatar = formValues["avatar"] {
			data["name"] = name as? String
			data["location"] = location as? String
			data["description"] = description as? String
//			data["avatar"] = avatar as? String
			delegate!.userDidFinishCompletingData(data)
			self.navigationController?.popViewControllerAnimated(true)
		} else {
			let alert = UIAlertController(title: "Alert", message: "Enter all data please", preferredStyle: UIAlertControllerStyle.Alert)
			alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}
}
