//
//  MapViewController.swift
//  FoodMe
//
//  Created by Sebastian Ottow on 14.03.23.
//

import Combine
import CoreLocation
import MapKit
import FloatingPanel
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
    
    private let _annotationList = [LocationModel]()
    private let _viewModel = LocationViewModel()

    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    
    private let _openMapDetailViewControllerButton = UIButton()
    private let _addNewEntryDetailViewControllerButton = UIButton()

    private var _cancellables: Set<AnyCancellable> = []
    
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

        let panel = FloatingPanelController()
        panel.set(contentViewController: LocationSearchViewController())
        panel.addPanel(toParent: self)

        navigationItem.title = "BioBande"

        let navigationBar = navigationController?.navigationBar
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.systemGreen]
        navigationBar?.scrollEdgeAppearance = navigationBarAppearance

        bind(viewModel: _viewModel)
    }

    private func bind(viewModel: LocationViewModel) {

        viewModel.$locationSearchResultCoordinates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coordinates in
                guard let self = self, let coordinates = coordinates else { return }

                self.mapView.removeAnnotations(self.mapView.annotations)

                let pin = MKPointAnnotation()
                pin.coordinate = coordinates
                self.mapView.addAnnotation(pin)

                self.mapView.setRegion(MKCoordinateRegion(
                    center: coordinates,
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.7,
                        longitudeDelta: 0.7
                    )
                ), animated: true)
            }
            .store(in: &_cancellables)
    }


    private func setupUI() {
        view.addSubview(mapView)
        mapView.frame = view.bounds
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
            let annotationCoordinate = "\(annotation.street) \(annotation.postalCode) \(annotation.city)"

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

                if let location = location {
                    self._longitude = location.coordinate.longitude
                    self._latitude = location.coordinate.latitude

                    self.addCustomPin(
                        latCoord: self._latitude,
                        longCoord: self._longitude,
                        entryTtitle: annotation.entryType
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

//extension MapViewController: LocationSearchViewDelegate {
//    func didSelectSearchResult(didSelectLocationWith coordinates: CLLocationCoordinate2D?) {
//        guard let coordinates = coordinates else { return }
//
//        mapView.removeAnnotations(mapView.annotations)
//
//        let pin = MKPointAnnotation()
//        pin.coordinate = coordinates
//        mapView.addAnnotation(pin)
//
//        mapView.setRegion(MKCoordinateRegion(
//            center: coordinates,
//            span: MKCoordinateSpan(
//                latitudeDelta: 0.7,
//                longitudeDelta: 0.7
//            )
//        ), animated: true)
//    }
//}
