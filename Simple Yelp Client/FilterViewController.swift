//
//  FilterViewController.swift
//  Simple Yelp Client
//
//  Created by Amit Bharadwaj on 9/22/14.
//  Copyright (c) 2014 Amit Bharadwaj. All rights reserved.
//

import UIKit

class FilterViewController: UITableViewController {
    
    var onDataAvailable : ((searchFilters: SearchFilters) -> ())?
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    // map to section to expanded or not
    var isExpanded:[Int:Bool]! = [Int:Bool]()
    
    var searchFilters:SearchFilters = SearchFilters()
    
    // TODO make these strings enum
    var sortByFilters:[String] = ["Distance", "Best Match", "Rating"]
    var radiusFilters:[String] = ["5000", "10000", "20000"]
    var categoryFilters: [[String]] = [
        ["breakfast_brunch", "Breakfast & Brunch"],
        ["asianfusion" , " Asian Fusion"],
        ["newamerican" , "New American"],
        ["japanese"  , "Japanese"],
        ["wine_bars" , "Wine Bars"],
        ["italian"  , "Italian"],
        ["buffets"  , "Buffets"],
        ["delis   " , "Delis"],
        ["sandwiches"  , "Sandwitches"],
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchFilters = SearchFilters()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4;
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Sort By"
        case 1:
            return "Radius"
        case 2:
            return "Deals"
        case 3:
            return "Categories"
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let expanded = isExpanded[section] {
            switch section {
            case 0:
                return expanded ? sortByFilters.count: 1
            case 1:
                return expanded ? radiusFilters.count: 1
            case 2:
                return 1
            case 3:
                return expanded ? categoryFilters.count: 3
            default:
                println("Got into default case of numberOfRowsInSection")
                return 1
            }
            
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var section = indexPath.section
        // println(section)
        switch section {
        case 0:
            var cell = tableView.dequeueReusableCellWithIdentifier("SortByCell") as SortByCell
            let sortByFilter = sortByFilters[indexPath.row]
            cell.sortByLabel.text = sortByFilter
            return cell
        case 1:
            var cell = tableView.dequeueReusableCellWithIdentifier("RadiusCell") as RadiusCell
            let radiusFilter = radiusFilters[indexPath.row]
            cell.radiusLabel.text = radiusFilter
            return cell
        case 2:
            var cell = tableView.dequeueReusableCellWithIdentifier("DealCell") as DealCell
            cell.dealSwitch.on = false
            return cell
        case 3:
            var cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as CategoryCell
            cell.categoryLabel.text = categoryFilters[indexPath.row][1]
            return cell

        default:
            println("Default case is cellForRowAtIndexPath")
        }
        return UITableViewCell()
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let section = indexPath.section
        
        switch section {
        case 0:
            let cell = tableView.cellForRowAtIndexPath(indexPath) as SortByCell
            searchFilters.sortByFilter = cell.sortByLabel.text!
        case 1:
            let cell = tableView.cellForRowAtIndexPath(indexPath) as RadiusCell
            searchFilters.radiusFilter = cell.radiusLabel.text!
        case 2:
            let cell = tableView.cellForRowAtIndexPath(indexPath) as DealCell
            searchFilters.dealFilter = cell.dealSwitch.on
        case 2:
            let cell = tableView.cellForRowAtIndexPath(indexPath) as CategoryCell
            searchFilters.categoryFilter.append(cell.categoryLabel.text!)
            // To be implemented
        default:
            println("default section case in didSelectRowAtIndexPath")
        }
        
        if let expanded = isExpanded[indexPath.section] {
            isExpanded[section] = !expanded
        } else {
            isExpanded[section] = true
        }
        
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Automatic)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSearchTapped(sender: AnyObject) {
        println("searchfilter: Just before sending to onDataAvaialble \(searchFilters.sortByFilter)")
        
        if (self.onDataAvailable == nil) {
            println(" on data avaialble is nil")
        }
        
        self.onDataAvailable!(searchFilters: searchFilters)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func onCancelTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
