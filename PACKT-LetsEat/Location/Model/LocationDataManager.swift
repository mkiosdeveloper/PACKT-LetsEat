//
//  LocationDataManager.swift
//  PACKT-LetsEat
//
//  Created by Warba on 18/06/2023.
//

import Foundation

class LocationDataManager {

    private var locations: [LocationItem] = []

    //MARK: - Functions
    func loadData() -> [[String: String]] {
        let decoder = PropertyListDecoder()
        if let path = Bundle.main.path(forResource: "Locations", ofType: "plist"),
           let locationsData = FileManager.default.contents(atPath: path),
           let locations = try? decoder.decode([[String: String]].self, from: locationsData) {
            return locations
        }
        return [[:]]
    } // loadData() -> [[String: String]]

    func fetch() {
        for location in loadData() {
            locations.append(LocationItem(dict: location))
        } // for
    } // fetch()

    func numberOfLocationsItems() -> Int {
        locations.count
    }
    func locationItem(at index: Int) -> LocationItem {
        locations[index]
    }
}
