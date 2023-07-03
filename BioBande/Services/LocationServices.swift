//
//  LocationServices.swift
//  FoodMeMVP_SO
//
//  Created by Sebastian Ottow on 23.06.23.
//

import Foundation
import FirebaseFirestore


class LocationServices {

    private let _db = Firestore.firestore()

    func saveAnnotationToDB(with locationRequest: LocationModel) {

        _db.collection("custom_locations").addDocument(data: [
            "userID":  locationRequest.userID,
            "isPrivate": locationRequest.isPrivate,
            "entryType": locationRequest.entryType,
            "street": locationRequest.street,
            "postalCode": locationRequest.postalCode,
            "city": locationRequest.city,
            "id": locationRequest.id,
            "longCoord": locationRequest.longCoord,
            "latCoord": locationRequest.latCoord
        ]) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully saved in db!!")
            }
        }
    }

    func fetchLocations(with locationSearchRequest: LocationSearchRequest, completion: (User?, Error?) -> Void) {

        _db.collection("custom_locations").getDocuments { [weak self] locationsData, error in
            print(locationsData)
        }

    }
}
