//
//  AnnotationModel.swift
//  FoodMeMVP_SO
//
//  Created by Sebastian Ottow on 26.03.23.
//

import UIKit
import RealmSwift


struct AnnotationModel {

    var userID: String
    var isPrivate: Bool

    var entryType: String

    var street: String
    var postalCode: String
    var city: String
    var id: String

    var longCoord: Double
    var latCoord: Double
}
