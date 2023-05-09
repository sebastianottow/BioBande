//
//  EntryCategoryModel.swift
//  FoodMeMVP_SO
//
//  Created by Sebastian Ottow on 11.05.23.
//

import Foundation
import RealmSwift

class EntryCategoryModel: Object, Codable {
    
    @Persisted var category: String
    @Persisted var name: String
    @Persisted var typeDescription: String
    
    enum CodingKeys: String, CodingKey {
        case category
        case name
        case typeDescription = "description"
    }
}




