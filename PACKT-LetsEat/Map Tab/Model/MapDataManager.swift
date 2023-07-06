//
//  MapDataManager.swift
//  PACKT-LetsEat
//
//  Created by Warba on 18/06/2023.
//

import Foundation
import MapKit

class MapDataManager: DataManager {
    
    private var items: [RestaurantItem] = []

    var annotations: [RestaurantItem] {
        items
    }

    //MARK: - Function

    func fetch(completion: (_ annotations: [RestaurantItem]) -> ()) {
        let manager = RestaurantDataManager()
        manager.fetch(location: "Boston", completionHandler: { restaurantItems in
            self.items = restaurantItems
            completion(items)
        })
    }

    func initialRegion(latDelta: CLLocationDegrees, longDelta: CLLocationDegrees) -> MKCoordinateRegion {
        guard let item = items.first else { return MKCoordinateRegion() }
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)

        return MKCoordinateRegion(center: item.coordinate, span: span)
    }
}
