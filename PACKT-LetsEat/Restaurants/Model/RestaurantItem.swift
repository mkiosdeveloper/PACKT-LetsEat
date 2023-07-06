//
//  RestaurantItem.swift
//  PACKT-LetsEat
//
//  Created by Warba on 18/06/2023.
//

import MapKit
import UIKit

class RestaurantItem: NSObject, MKAnnotation, Decodable {

    // MARK: - MKAnnotation Protocol conformance
    var coordinate: CLLocationCoordinate2D {
        guard let lat = lat, let long = long else {
            return CLLocationCoordinate2D()
        }
        return CLLocationCoordinate2D(latitude: lat,
                                      longitude: long)
    }

    var title: String? {
        name
    }

    var subtitle: String? {
        if cuisines.isEmpty {
            return ""
        } else if cuisines.count == 1 {
            return cuisines.first
        } else {
            return cuisines.joined(separator: ", ")
        }
    }

    // MARK: - Properties and init()

    let name: String?
    let cuisines: [String]
    let lat: Double?
    let long: Double?
    let address: String?
    let postalCode: String?
    let state: String?
    let imageURL: String?
    let restaurantID: Int?

    enum CodingKeys: String, CodingKey {
        case name
        case cuisines
        case lat
        case long
        case address
        case postalCode = "postal_code"
        case state
        case imageURL = "image_url"
        case restaurantID = "id"
    }
}
