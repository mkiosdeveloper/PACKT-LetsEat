//
//  ExploreItem.swift
//  PACKT-LetsEat
//
//  Created by Warba on 15/06/2023.
//

import Foundation
import UIKit



struct ExploreItem {
    let name: String?
    let image: String?
}

extension ExploreItem {
    init(dict: [String: String]) {
        self.name = dict["name"]
        self.image = dict["image"]
    }
}

class ExploreDataManager: DataManager {

    private var exploreItems: [ExploreItem] = []

    func fetch() {
        for data in loadPlist(file: "ExploreData") {
            exploreItems.append(ExploreItem(dict: data as! [String: String]))
        }
    }

    private func loadData() -> [[String: String]] {
        let decoder = PropertyListDecoder()
        if let path = Bundle.main.path(forResource: "ExploreData", ofType: "plist"),
           let exploreData = FileManager.default.contents(atPath: path),
           let exploreItems = try? decoder.decode([[String: String]].self, from: exploreData) {
            return exploreItems
        }
        return [[:]]
    }

    func numberOfExploreItems() -> Int {
        exploreItems.count
    }
    func exploreitem(at index: Int) -> ExploreItem {
        exploreItems[index]
    }
}
