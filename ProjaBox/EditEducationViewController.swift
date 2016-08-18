//
//  EditEducationViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 09/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import Eureka

protocol ExperienceInputDelegate {
	func finishedCompletingItem(item: [String: String])
}

class EditEducationViewController: FormViewController {
	
	var delegate: ExperienceInputDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.form +++=  TextRow("university") {
			$0.title = "University"
			$0.placeholder = "Type it in"
			}
			<<< DateRow("start-date")	{
				$0.title = "Start date"
				$0.value = NSDate()
				let formatter = NSDateFormatter()
				formatter.locale = .currentLocale()
				formatter.dateStyle = .ShortStyle
				$0.dateFormatter = formatter
			}
			<<< DateRow("end-date") {
				$0.title = "End date"
				$0.value = NSDate()
				let formatter = NSDateFormatter()
				formatter.locale = .currentLocale()
				formatter.dateStyle = .ShortStyle
				$0.dateFormatter = formatter
			} <<< ButtonRow() { (row: ButtonRow) -> Void in
				row.title = "Done"
				}  .onCellSelection({ (cell, row) in
					self.sendData()
				})
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(self.cancelButtonPressed(_:)))
	}
	
	func cancelButtonPressed(sender: UIBarButtonItem) {
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	func sendData() {
		var data = [String: String]()
		let values = self.form.values()
		
		if let university = values["university"],
			let startDate = values["start-date"],
			let endDate = values["end-date"] {
			if university != nil {
				let startDateString = formatDate(startDate as! NSDate)
				let endDateString = formatDate(endDate as! NSDate)
				
				data["university"] = (university as! String)
				data["start"] = startDateString
				data["finish"] = endDateString
				
				delegate?.finishedCompletingItem(data)
				self.navigationController?.popViewControllerAnimated(true)
			}
		} else {
			let alert = UIAlertController(title: "Alert", message: "Enter all data please", preferredStyle: UIAlertControllerStyle.Alert)
			alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	private func formatDate(date: NSDate) -> String {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		
		return dateFormatter.stringFromDate(date)
	}
}

