//
//  AnnotationViewModel.swift
//  FoodMeMVP_SO
//
//  Created by Sebastian Ottow on 26.03.23.
//

import Combine
import CoreLocation
import UIKit
import RealmSwift


class AnnotationViewModel: ObservableObject {
    
    let realm = try! Realm()
    
    let _categoryList = try! Realm().objects(CategoryModel.self)

    let annotationServices = AnnotationServices()
        
    var entries = [AnnotationModel]()
    
    @Published var street: String = ""
    @Published var postalCode: String = ""
    @Published var city: String = ""
    @Published var longCoord: Double = 0
    @Published var latCoord: Double = 0.0
    @Published var isPrivate: Bool = false

    func forwardGeocoding(street: String, postalCode: String, city: String, completion: @escaping (Bool, Error?) -> Void) {

        let address = "\(street) \(postalCode) \(city)"

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print("Failed to retrieve location: \(error)")
                completion(false, error)
                return
            }

            var location: CLLocation?

            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }

            if let location = location {
                self.longCoord = location.coordinate.longitude
                self.latCoord = location.coordinate.latitude

                completion(true, nil)
            }
            else
            {
                guard let error = error else { return }
                print("No matching location found: \(error)")
                completion(false, error)
            }
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
