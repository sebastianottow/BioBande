//
//  AnnotationViewModel.swift
//  FoodMeMVP_SO
//
//  Created by Sebastian Ottow on 26.03.23.
//

import Combine
import UIKit
import RealmSwift


class AnnotationViewModel: ObservableObject {
    
    let realm = try! Realm()
    
    let _categoryList = try! Realm().objects(CategoryModel.self)
        
    var entries = [AnnotationModel]()
    
    @Published var street: String = ""
    @Published var postalCode: String = ""
    @Published var city: String = ""

    func addNewEntry(
        entryType: String,
        street: String,
        postalCode: String,
        city: String,
        id: String
    ) {
        let entry = AnnotationModel()
        
        entry.entryType = entryType
        entry.street = street
        entry.postalCode = postalCode
        entry.city = city
        entry.id = id
        
        self.entries.append(entry)
        
        try! realm.write {
            realm.add(entry)
        }
    }
}

extension AnnotationViewModel {
    
    var isValidStreetPublisher: AnyPublisher<Bool, Never> {
        $street
            .map { $0.count > 3 }
            .eraseToAnyPublisher()
    }
    
    var isValidPostalCodePublisher: AnyPublisher<Bool, Never> {
        $postalCode
            .map { $0.count == 5 }
            .eraseToAnyPublisher()
    }
    
    var isValidCityPublisher: AnyPublisher<Bool, Never> {
        $city
            .map { $0.count > 3 }
            .eraseToAnyPublisher()
    }
    
    var isAddNewEntryButtonEnabled: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isValidStreetPublisher, isValidPostalCodePublisher, isValidCityPublisher)
            .map { $0 && $1 && $2 }
            .eraseToAnyPublisher()
    }
}
