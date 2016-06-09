
//
//  EditInterestsViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 09/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import TagListView

class EditInterestsViewController: UIViewController {
	
	@IBOutlet weak var tagListView: TagListView?
	@IBOutlet weak var tagTextField: UITextField?
	
	var interestsList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	@IBAction func addButtonPressed() {
		
	}
}
