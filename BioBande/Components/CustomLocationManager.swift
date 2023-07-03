//
//  CustomLocationManager.swift
//  BioBande
//
//  Created by Sebastian Ottow on 03.07.23.
//

import Foundation
import CoreLocation

struct Location {
    var title: String
    var coordinates: CLLocationCoordinate2D?
}

class CustomLocationManager: NSObject {

    static let shared = CustomLocationManager()

    let manager = CLLocationManager()

    public func findLocations(with query: String, completion: @escaping (([Location]) -> Void)) {
        let geoCoder = CLGeocoder()

        geoCoder.geocodeAddressString(query) { locations, error in
            guard let locations = locations, error == nil else {
                completion([])
                return
            }

            let models: [Location] = locations.compactMap({ location in
                var name = ""

                if let locationName = location.name {
                    name += locationName
                }

                if let adminRegion = location.administrativeArea {
                    name += ", \(adminRegion)"
                }

                if let locality = location.locality {
                    name += ", \(locality)"
                }

                if let country = location.country {
                    name += ", \(country)"
                }

                print("\n\(location)\n\n")

                let result = Location(
                    title: name,
                    coordinates: location.location?.coordinate
                )

                return result
            })

            completion(models)
        }


    }
}
