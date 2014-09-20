//
//  ViewController.swift
//  Simple Yelp Client
//
//  Created by Amit Bharadwaj on 9/20/14.
//  Copyright (c) 2014 Amit Bharadwaj. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var dataArray: NSArray?

    var client: YelpClient!
    
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
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        client.searchWithTerm("Thai", success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//             println(response)
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
        
        return cell
    }
    
}

