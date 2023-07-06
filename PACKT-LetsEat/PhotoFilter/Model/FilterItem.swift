//
//  FilterItem.swift
//  PACKT-LetsEat
//
//  Created by Warba on 25/06/2023.
//

import Foundation

struct FilterItem {
    let filter: String?
    let name: String?

    init(dict: [String: String]) {
        self.filter = dict["filter"]
        self.name = dict["name"] 
    }
}
