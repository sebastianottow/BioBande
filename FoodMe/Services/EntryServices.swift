//
//  EntryServices.swift
//  FoodMeMVP_SO
//
//  Created by Sebastian Ottow on 09.05.23.
//

import Combine
import Foundation
import FirebaseFirestore
import RealmSwift

class EntryCategoryServices {
    
    let realm = try! Realm()
    
    let _entryCategoryList = try! Realm().objects(EntryCategoryModel.self).sorted(byKeyPath: "name", ascending: true)
    
    let database = Firestore.firestore()
        
    // MARK: fetch entry category options from firestore
//
//    func fetchEntryCategories() {
//
//        let snapshot = database.collection("entry_categories").getDocuments()
//        let documents = snapshot.documents
//
//        var entryCategories = [EntryCategoryModel]()
//
//        for document in documents {
//
//            let entryCategory = EntryCategoryModel()
//
//            entryCategory.category = document.data()["category"] as! String
//            entryCategory.name = document.data()["name"] as! String
//            entryCategory.typeDescription = document.data()["description"] as! String
//
//            entryCategories.append(entryCategory)
//        }
//        listenToCategoryChangesInDatabase()
//    }
    
    func fetchEntryCategories() {
        database.collection("entry_categories").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents. \(err)")
            } else {
                guard let querySnapshot = querySnapshot else { return }
                for document in querySnapshot.documents {

                    let entryCategory = EntryCategoryModel()
                    entryCategory.category = document.data()["category"] as! String
                    entryCategory.name = document.data()["name"] as! String
                    entryCategory.typeDescription = document.data()["description"] as! String

                    try! self.realm.write {
                        self.realm.add(entryCategory)
                    }
                }
            }
        }
    }
        
    func updateEntryCategories() {
//        database.collection ("entry_categories").addSnapshotListener { [weak self] querySnapshot, error in
//
//            guard let snapshot = querySnapshot?.documents, error == nil else {
//                return
//            }
//
//            var entryCategories = [EntryCategoryModel]()
        
        let entryCategories = self.database.collection("entry_categories")
        entryCategories.addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
            
                snapshot.documentChanges.forEach { diff in
                    let entryCategory = diff.document.get("name") as? String ?? ""
                    if (diff.type == .added) {
                        //                try! realm.write {
                        //                    realm.add(entryCategory)
                        //                }
                        print("Added category: \(entryCategory)")
                    }
                    if (diff.type == .modified) {
                        print("Modified category: \(entryCategory)")
                    }
                    if (diff.type == .removed) {
                        print("Removed category: \(entryCategory)")
                    }
        }
//
//            for document in snapshot.documents {
//
//                let entryCategory = EntryCategoryModel()
//
//                entryCategory.category = document.data()["category"] as! String
//                entryCategory.name = document.data()["name"] as! String
//                entryCategory.typeDescription = document.data()["description"] as! String
//
//                entryCategories.append(entryCategory)
//
//                try! self?.realm.write {
//                    self?.realm.add(entryCategory)
//                }
//            }
        }
    }
}
