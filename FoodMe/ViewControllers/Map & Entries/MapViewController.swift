//
//  MapViewController.swift
//  FoodMe
//
//  Created by Sebastian Ottow on 14.03.23.
//

import CoreLocation
import MapKit
import RealmSwift
import TinyConstraints
import UIKit


class MapViewController: UIViewController {
    
    private enum Constants {
        static let fruitIcon = UIImage(systemName: "apple.logo")
        static let veggieIcon = UIImage(systemName: "carrot.fill")
        static let meatIcon = UIImage(systemName: "hare.fill")
    }
    
    let mapView = MKMapView()

    private var _longitude = CLLocationCoordinate2D().longitude
    private var _latitude = CLLocationCoordinate2D().latitude
    
    private let _annotationList = try! Realm().objects(AnnotationModel.self)

    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    
    private let _openMapDetailViewControllerButton = UIButton()
    private let _addNewEntryDetailViewControllerButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        mapView.showsUserLocation = true

        setupUI()
        
        mapView.delegate = self
        
        forwardGeocoding()
    }

    private func setupUI() {
        view.addSubview(mapView)
        mapView.frame = view.bounds
        
        view.addSubview(_addNewEntryDetailViewControllerButton)
        configureAddNewEntryDetailViewControllerButton()
        _addNewEntryDetailViewControllerButton.edgesToSuperview(excluding: [.top, .left], insets: .init(top: 0, left: 0, bottom: 100, right: 40))

        
        view.addSubview(_openMapDetailViewControllerButton)
        configureOpenMapDetailViewControllerButton()
        _openMapDetailViewControllerButton.edgesToSuperview(excluding: [.top, .left], insets: .init(top: 0, left: 0, bottom: 40, right: 40))
    }

    private func configureOpenMapDetailViewControllerButton() {
        _openMapDetailViewControllerButton.configuration = .filled()
        _openMapDetailViewControllerButton.configuration?.buttonSize = .large
        _openMapDetailViewControllerButton.configuration?.baseForegroundColor = .systemGreen
        _openMapDetailViewControllerButton.configuration?.baseBackgroundColor = .systemIndigo
        _openMapDetailViewControllerButton.configuration?.image = UIImage(
            systemName: "magnifyingglass",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 20,
                weight: .bold
            )
        )
        _openMapDetailViewControllerButton.configuration?.cornerStyle = .capsule

        _openMapDetailViewControllerButton.isEnabled = true

        _openMapDetailViewControllerButton.addTarget(
            self,
            action: #selector(presentSearchAnnotationsViewController),
            for: .touchUpInside
        )
    }
    
    private func configureAddNewEntryDetailViewControllerButton() {
        _addNewEntryDetailViewControllerButton.configuration = .filled()
        _addNewEntryDetailViewControllerButton.configuration?.buttonSize = .large
        _addNewEntryDetailViewControllerButton.configuration?.baseForegroundColor = .systemGreen
        _addNewEntryDetailViewControllerButton.configuration?.baseBackgroundColor = .systemIndigo
        _addNewEntryDetailViewControllerButton.configuration?.image = UIImage(
            systemName: "plus",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 20,
                weight: .bold
            )
        )
        _addNewEntryDetailViewControllerButton.configuration?.cornerStyle = .capsule

        _addNewEntryDetailViewControllerButton.isEnabled = true

        _addNewEntryDetailViewControllerButton.addTarget(
            self,
            action: #selector(presentNewAnnotationEntryViewController),
            for: .touchUpInside
        )
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus{
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location is restricted!")
        case .denied:
            print("Location Services are denied")
        case .authorizedWhenInUse, .authorizedAlways:
            /// app is authorized
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func forwardGeocoding() {
        let annotations = _annotationList

        for annotation in annotations {
            let annotationCoordinate = "\(annotation.street ?? "") \(annotation.postalCode ?? "") \(annotation.city ?? "")"

            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(annotationCoordinate, completionHandler: { (placemarks, error) in
                if error != nil {
                    print("Failed to retrieve location")
                    return
                }

                var location: CLLocation?

                if let placemarks = placemarks, placemarks.count > 0 {
                    location = placemarks.first?.location
                }

                if let location = location, let entryType = annotation.entryType {
                    self._longitude = location.coordinate.longitude
                    self._latitude = location.coordinate.latitude

                    self.addCustomPin(
                        latCoord: self._latitude,
                        longCoord: self._longitude,
                        entryTtitle: entryType
                    )
                }
                else
                {
                    print("No Matching Location Found")
                }
            })
        }
    }
    
    private func addCustomPin(
        latCoord: CLLocationDegrees,
        longCoord: CLLocationDegrees,
        entryTtitle: String
    ) {
            let customPin = MKPointAnnotation()
            customPin.coordinate = CLLocationCoordinate2D(latitude: latCoord, longitude: longCoord)
            customPin.title = entryTtitle
            mapView.addAnnotation(customPin)
    }
    
    @objc func presentNewAnnotationEntryViewController() {
        let newAnnotationEntryViewController = NewAnnotationEntryViewController()
        let nav = UINavigationController(rootViewController: newAnnotationEntryViewController)
        
        //1
        nav.modalPresentationStyle = .pageSheet
        
        //2
        if let sheet = nav.sheetPresentationController {
            
            //3
            sheet.detents = [.medium(), .large()]
        }
        
        //4
        present(nav, animated: true, completion: nil)
    }
    
    @objc func presentSearchAnnotationsViewController() {
        let searchAnnotationsViewController = SearchAnnotationsViewController()
        let nav = UINavigationController(rootViewController: searchAnnotationsViewController)
        
        //1
        nav.modalPresentationStyle = .pageSheet
        
        //2
        if let sheet = nav.sheetPresentationController {
            
            //3
            sheet.detents = [.medium(), .large()]
        }
        
        //4
        present(nav, animated: true, completion: nil)
    }
}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}


extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
}


extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationEntries = _annotationList
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "entry")
        
        for entry in annotationEntries {
            
            guard !(annotation is MKUserLocation) else {
                return nil
            }
            
            if annotationView == nil {
                annotationView = MKAnnotationView(
                    annotation: annotation,
                    reuseIdentifier: "entry"
                )
                annotationView?.canShowCallout = true
                switch entry.entryType {
                case "Obstbaum": annotationView?.image = Constants.fruitIcon
                case "Gemüse": annotationView?.image = Constants.veggieIcon
                case "Fleisch": annotationView?.image = Constants.meatIcon
                default: return nil
                }
                //            annotationView?.image = Constants.veggieIcon
                
            } else {
                annotationView?.annotation = annotation
            }
        }
        
        return annotationView
    }
}
