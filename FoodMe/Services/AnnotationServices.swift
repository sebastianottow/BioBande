//
//  AnnotationServices.swift
//  FoodMeMVP_SO
//
//  Created by Sebastian Ottow on 23.06.23.
//

import Foundation
import FirebaseFirestore


class AnnotationServices {

    private let _db = Firestore.firestore()

    func saveAnnotationToDB(with annotationRequest: AnnotationModel) {

        _db.collection("customAnnotations").addDocument(data: [
            "userID":  annotationRequest.userID,
            "isPrivate": annotationRequest.isPrivate,
            "entryType": annotationRequest.entryType,
            "street": annotationRequest.street,
            "postalCode": annotationRequest.postalCode,
            "city": annotationRequest.city,
            "id": annotationRequest.id,
            "longCoord": annotationRequest.longCoord,
            "latCoord": annotationRequest.latCoord
        ]) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully saved in db!!")
            }
        }
    }
}
