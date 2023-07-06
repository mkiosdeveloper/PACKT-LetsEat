//
//  FilterDataManager.swift
//  PACKT-LetsEat
//
//  Created by Warba on 25/06/2023.
//

import Foundation

/// Class for fetching and reading photo filters 
class FilterDataManager: DataManager {
    func fetch() -> [FilterItem] {
        var filterItems: [FilterItem] = []
        for data in loadPlist(file: "FilterData") {
            filterItems.append(FilterItem(dict: data as! [String: String]))
        }
        return filterItems
    }
}
