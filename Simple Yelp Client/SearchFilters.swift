//
//  SearchFilters.swift
//  Simple Yelp Client
//
//  Created by Amit Bharadwaj on 9/23/14.
//  Copyright (c) 2014 Amit Bharadwaj. All rights reserved.
//

struct SearchFilters {
    var sortByFilter: String = ""
    var radiusFilter: String = "5000"
    var dealFilter: Bool = false
    var categoryFilter: [String] = [""]
}
