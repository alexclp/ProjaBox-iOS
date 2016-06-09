//
//  EditBioViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 09/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import Eureka

class EditBioViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		self.navigationItem.hidesBackButton = true
		
		setupForm()
    }
	
	func setupForm() {
		self.form +++=  TextRow("work") {
			$0.title = "Name"
			$0.placeholder = "Type your name"
			}
			<<< TextRow("location") {
				$0.title = "Location"
				$0.placeholder = "Type your location"
			}
			<<< TextRow("position") {
				$0.title = "Position"
				$0.placeholder = "Type in your position"
			}
			<<< TextRow("status") {
				$0.title = "Status"
				$0.placeholder = "e.g. Looking for a team"
			}
			<<< TextRow("description") {
				$0.title = "Description"
				$0.placeholder = "Short bio"
			}
			<<< SegmentedRow<String>("sex"){
				$0.title = "Sex"
				$0.options = ["M", "F"]
			}
			<<< ImageRow("profile-picture"){
				$0.title = "Profile Picture"
			}
			<<< ButtonRow() { (row: ButtonRow) -> Void in
				row.title = "Done"
				}  .onCellSelection({ (cell, row) in
					self.doneButtonPressed()
			})
	}
	
	func doneButtonPressed() {
		self.navigationController?.popViewControllerAnimated(true)
	}
}