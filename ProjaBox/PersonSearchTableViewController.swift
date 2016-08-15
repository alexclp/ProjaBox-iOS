//
//  PersonSearchTableViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 15/08/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class PersonSearchTableViewController: UIViewController, UISearchBarDelegate {
	
	let searchController = UISearchController(searchResultsController: nil)
	var searchResults = [User]()
	var selectedIndex = Int()
	
	@IBOutlet weak var tableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		searchController.searchBar.delegate = self
		searchController.dimsBackgroundDuringPresentation = false
		definesPresentationContext = true
		tableView.tableHeaderView = searchController.searchBar
    }
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		SearchHelper.searchForUsers(searchBar.text!) { (response, results) in
			if response == true {
				self.searchResults = results!
				self.tableView.reloadData()
			}
		}
	}
	
    // MARK: - Table view data source

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

	
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        cell.textLabel?.text = searchResults[indexPath.row].name

        return cell
    }
	
	// MARK: - Table view delegate
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		selectedIndex = indexPath.row
		
		performSegueWithIdentifier("showConversationSegue", sender: self)
	}
	
	
	// MARK: - Navigation
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showConversationSegue" {
			let destination = segue.destinationViewController as! ConversationViewController
			destination.profileId = String(searchResults[selectedIndex].id!)
		}
	}
}
