//
//  ViewController.swift
//  Simple Yelp Client
//
//  Created by Amit Bharadwaj on 9/20/14.
//  Copyright (c) 2014 Amit Bharadwaj. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var dataArray: NSArray?
    
    var client: YelpClient!
    var searchStr: String = "Indian Restaurant"
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let yelpConsumerKey =  "Csht0nQt0qEhaYKU750zxg" // "vxKwwcR_NMQ7WaEiQBK_CA"
    let yelpConsumerSecret =  "CFOePRde3v5JNa48o6QgL9ObSng" // "33QCvh5bIF5jIHR5klQr7RtBDhQ"
    let yelpToken = "E-CUEnnGadusO8Sn2ljBbkZ0f-RA5Ge3" // "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
    let yelpTokenSecret = "si0QwvtBHWqnGBnRCPB44sP_I5s" // "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: How to add search bar using story board
        // TODO: Use auto layout on search bar
        // TODO: put search bar below title
        
        let searchBar: UISearchBar = UISearchBar(frame: CGRectMake(0.0, 0.0, 300.0, 44.0))
        //self.navigationController?.navigationBar.addSubview(searchBar)
        self.navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        
        // Do any additional setup after loading the view, typically from a nib.
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        // Default query
        client.searchWithTerm(searchStr, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //            println(response)
            //            println("=============\n")
            let responseDict = response as Dictionary<String, AnyObject>
            self.dataArray = responseDict["businesses"] as NSArray?
            self.tableView.reloadData()
            //let locationDict = resultArray[0]["location"] as Dictionary<String, AnyObject>
            // println(locationDict["city"])
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO potential null exception
        if (dataArray == nil) {
            return 0
        }
        return dataArray!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("yelpcell") as YelpCell
        let cellData = dataArray![indexPath.row] as NSDictionary
        cell.nameLabel.text = cellData["name"] as? String
        
        let posterImageUrl = NSURL(string: cellData["image_url"] as NSString)
        cell.posterImageView.setImageWithURL(posterImageUrl)
        
        let ratingImageUrl = NSURL(string: cellData["rating_img_url"] as NSString)
        cell.starImageView.setImageWithURL(ratingImageUrl)
        
        let locationDict = cellData["location"] as NSDictionary
        let address = locationDict["address"] as [String]
        let city = locationDict["city"] as String
        
        let neighborhoods = locationDict["neighborhoods"] as [String]
        let neighborhoodString = neighborhoods[0]
        
        cell.addressLabel.text = "\(address[0]), \(neighborhoodString)"
        
        // categories
        let categoriesData = cellData["categories"] as [[String]]
        var categoriesString: String = ""
        for categoryData in categoriesData {
            if (categoriesString != "") {
                categoriesString += ", "
            }
            categoriesString += categoryData[0]
        }
        
        // println(categoriesString)
        
        cell.categoriesLabel.text = categoriesString
        
        return cell
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        searchStr = searchBar.text
        
        client.searchWithTerm(searchStr, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //            println(response)
            //            println("=============\n")
            let responseDict = response as Dictionary<String, AnyObject>
            self.dataArray = responseDict["businesses"] as NSArray?
            self.tableView.reloadData()
            //let locationDict = resultArray[0]["location"] as Dictionary<String, AnyObject>
            // println(locationDict["city"])
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nvc = segue.destinationViewController as?  UINavigationController //FilterViewController
        
        //        if (nvc == nil) {
        //            println("destination view controller for segue is null")
        //        } else {
        //            println("destination view controller is navigation controller and it is not null")
        //        }
        
        let fvc = nvc?.topViewController as FilterViewController
        
        fvc.onDataAvailable = {[weak self]
            (searchFilters: SearchFilters) -> () in
            if let weakSelf = self {
                weakSelf.runSearchAgain(searchFilters)
            }
        }
    }
    
    func runSearchAgain(searchFilters: SearchFilters) {
        println(" Filters are \(searchFilters.sortByFilter) , \(searchFilters.radiusFilter), \(searchFilters.dealFilter)")
        
        client.searchWithFilters(searchStr, searchFilters: searchFilters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //            println(response)
            //            println("=============\n")
            let responseDict = response as Dictionary<String, AnyObject>
            self.dataArray = responseDict["businesses"] as NSArray?
            self.tableView.reloadData()
            //let locationDict = resultArray[0]["location"] as Dictionary<String, AnyObject>
            // println(locationDict["city"])
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
        
    }
    
}

