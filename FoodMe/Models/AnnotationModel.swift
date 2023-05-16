//
//  AnnotationModel.swift
//  FoodMeMVP_SO
//
//  Created by Sebastian Ottow on 26.03.23.
//

import UIKit
import RealmSwift


class AnnotationModel: Object {
    @Persisted var entryType: String?
    @Persisted var street: String?
    @Persisted var postalCode: String?
    @Persisted var city: String?
    @Persisted var id: String?
}
