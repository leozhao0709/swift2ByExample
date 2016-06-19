//
//  SearchResultsController.swift
//  Sections
//
//  Created by Lei Zhao on 6/19/16.
//  Copyright © 2016 Lei Zhao. All rights reserved.
//

import UIKit

class SearchResultsController: UITableViewController, UISearchResultsUpdating {
    
    let sectionsTableIdentifier = "SectionsTableIdentifier"
    var names: [String: [String]] = [String: [String]]()
    var keys: [String] = []
    var filteredNames: [String] = []
    
    private static let longNameSize = 6
    private static let shortNamesButtonIndex = 1
    private static let longNameButtonIndex = 2

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: sectionsTableIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(sectionsTableIdentifier)
        cell?.textLabel?.text = filteredNames[indexPath.row]
        return cell!
    }
    
    // MARK: UISearchResultsUpdating Conformance
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchString = searchController.searchBar.text{
            let buttonIndex = searchController.searchBar.selectedScopeButtonIndex
            filteredNames.removeAll(keepCapacity: true)
            
            if !searchString.isEmpty {
                let filter: String -> Bool = { name in
                    let nameLength = name.characters.count
                    if (buttonIndex == SearchResultsController.shortNamesButtonIndex && nameLength >= SearchResultsController.longNameSize) || (buttonIndex == SearchResultsController.longNameButtonIndex && nameLength < SearchResultsController.longNameSize) {
                        return false
                    }
                    
                    let range = name.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch)
                    return range != nil
                }
                
                for key in keys {
                    let namesForKey = names[key]!
                    let matches = namesForKey.filter(filter)
                    filteredNames += matches
                }
            }
            
            tableView.reloadData()
        }
        
    }

}
