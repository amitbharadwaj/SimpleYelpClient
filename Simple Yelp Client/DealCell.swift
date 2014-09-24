//
//  DealCell.swift
//  Simple Yelp Client
//
//  Created by Amit Bharadwaj on 9/23/14.
//  Copyright (c) 2014 Amit Bharadwaj. All rights reserved.
//

import UIKit

class DealCell: UITableViewCell {

    @IBOutlet weak var dealSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
