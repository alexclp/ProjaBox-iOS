//
//  EditBioViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 09/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import Eureka

protocol BioDataDelegate {
	func userDidFinishCompletingData(bioData: [String: AnyObject])
}

class EditBioViewController: FormViewController {
	
	var delegate: BioDataDelegate?
	var formData = [String: AnyObject]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		self.navigationItem.hidesBackButton = true
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(self.cancelButtonPressed(_:)))
		
		setupForm()
	}
	
	func cancelButtonPressed(sender: UIBarButtonItem) {
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	func setupForm() {
		self.form +++=  TextRow("name") {
			$0.title = "Name"
			$0.placeholder = "Type your name"
			}
			<<< TextRow("location") {
				$0.title = "Location"
				$0.placeholder = "Type your location"
			}
			<<< TextRow("occupation") {
				$0.title = "Position"
				$0.placeholder = "Type in your position"
			}
			<<< TextRow("status") {
				$0.title = "Status"
				$0.placeholder = "e.g. Looking for a team"
			}
			<<< TextRow("about") {
				$0.title = "Description"
				$0.placeholder = "Short bio"
			}
			<<< SegmentedRow<String>("sex"){
				$0.title = "Sex"
				$0.options = ["M", "F"]
			}
			<<< ImageRow("avatar"){
				$0.title = "Profile Picture"
			}
			<<< ButtonRow() { (row: ButtonRow) -> Void in
				row.title = "Done"
				}  .onCellSelection({ (cell, row) in
					self.doneButtonPressed()
				})
	}
	
	func doneButtonPressed() {
		let rawData = self.form.values()
		if let name = rawData["name"], let location = rawData["location"], let position = rawData["occupation"], let status = rawData["status"],
			let description = rawData["about"], let sex = rawData["sex"], let avatar = rawData["avatar"]  {
			
			if name != nil && location != nil && position != nil && status != nil && description != nil && sex != nil && avatar != nil {
				formData["name"] = name as! String
				formData["location"] = location as! String
				formData["occupation"] = position as! String
				formData["status"] = status as! String
				formData["about"] = description as! String
				formData["sex"] = sex as! String
				formData["avatar"] = CompressedImage.encodeImageLowetQuality(avatar as! UIImage)
				delegate?.userDidFinishCompletingData(formData)
				self.navigationController?.popViewControllerAnimated(true)
			} else {
			let alert = UIAlertController(title: "Alert", message: "Enter all data please", preferredStyle: UIAlertControllerStyle.Alert)
			alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
			self.presentViewController(alert, animated: true, completion: nil)
			}
		}
	}
}