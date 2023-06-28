//
//  CategoryServices.swift
//  FoodMeMVP_SO
//
//  Created by Sebastian Ottow on 09.05.23.
//

import Combine
import Foundation
import FirebaseFirestore
import RealmSwift

class CategoryServices {
    
    let realm = try! Realm()
    
    private let _categoryList = try! Realm().objects(CategoryModel.self).sorted(byKeyPath: "name", ascending: true)
    
    private let _db = Firestore.firestore()
    
    func fetchCategories() {
        _db.collection("entry_categories").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents. \(err)")
            } else {
                guard let querySnapshot = querySnapshot else { return }
                for document in querySnapshot.documents {

                    let category = CategoryModel()
                    category.categoryID = document.documentID
                    category.category = document.data()["category"] as! String
                    category.name = document.data()["name"] as! String
                    category.typeDescription = document.data()["description"] as! String

                    if self._categoryList.contains(where: { $0.categoryID == category.categoryID }) {
                        continue
                    } else {
                        try! self.realm.write {
                            self.realm.add(category)
                        }
                    }
                }
            }
        }
    }
}
