//
//  EditExperienceViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 09/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import Eureka

class EditExperienceViewController: FormViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		self.form +++=  TextRow("Workplace name") {
			$0.title = "Workplace"
			$0.placeholder = "Type it in"
			}
			<<< DateRow("Start Date")	{
				$0.title = "Short style"
				$0.value = NSDate()
				let formatter = NSDateFormatter()
				formatter.locale = .currentLocale()
				formatter.dateStyle = .ShortStyle
				$0.dateFormatter = formatter
			}
			<<< DateRow("End Date") {
				$0.title = "Short style"
				$0.value = NSDate()
				let formatter = NSDateFormatter()
				formatter.locale = .currentLocale()
				formatter.dateStyle = .ShortStyle
				$0.dateFormatter = formatter
			}
			<<< ButtonRow() { (row: ButtonRow) -> Void in
				row.title = "Done"
				}  .onCellSelection({ (cell, row) in
			})
	}
}
