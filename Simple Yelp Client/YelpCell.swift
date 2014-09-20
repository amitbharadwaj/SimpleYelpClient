//
//  YelpCellTableViewCell.swift
//  Simple Yelp Client
//
//  Created by Amit Bharadwaj on 9/20/14.
//  Copyright (c) 2014 Amit Bharadwaj. All rights reserved.
//

import UIKit

class YelpCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
