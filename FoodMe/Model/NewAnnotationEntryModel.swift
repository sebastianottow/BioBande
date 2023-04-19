//
//  NewAnnotationEntryModel.swift
//  FoodMeMVP_SO
//
//  Created by Sebastian Ottow on 26.03.23.
//

import UIKit
import RealmSwift


class NewAnnotationEntryModel: Object {
    @objc dynamic var entryType: String?
    @objc dynamic var street: String?
    @objc dynamic var postalCode: String?
    @objc dynamic var city: String?
    @objc dynamic var id: String?
}
