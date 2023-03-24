//
//  MapViewController.swift
//  FoodMe
//
//  Created by Sebastian Ottow on 14.03.23.
//

import TinyConstraints
import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController {
    
    let mapView = MKMapView()
    
    private var _longitude = CLLocationCoordinate2D().longitude
    private var _latitude = CLLocationCoordinate2D().latitude
    
    let address = "1 Infinite Loop, Cupertino, CA 95014"

    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    
    private let _openMapDetailViewControllerButton = UIButton()

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
        
        forwardGeocoding(address: address)
    }

    private func setupUI() {
        view.addSubview(mapView)
        mapView.frame = view.bounds
        
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
            systemName: "slider.horizontal.3",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 20,
                weight: .bold
            )
        )
        _openMapDetailViewControllerButton.configuration?.cornerStyle = .capsule

        _openMapDetailViewControllerButton.isEnabled = true

        _openMapDetailViewControllerButton.addTarget(
            self,
            action: #selector(presentMapDetailViewController),
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
    
    func forwardGeocoding(address: String) {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
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
                    
                    print("\nlat: \(self._latitude), long: \(self._longitude)")
                    
                    self.addCustomPin(latCoord: self._latitude, longCoord: self._longitude)
                }
                else
                {
                    print("No Matching Location Found")
                }
            })
        }
    
    private func addCustomPin(
        latCoord: CLLocationDegrees,
        longCoord: CLLocationDegrees
    ) {
            let customPin = MKPointAnnotation()
            customPin.coordinate = CLLocationCoordinate2D(latitude: latCoord, longitude: longCoord)
            customPin.title = "BeispielBaum"
            customPin.subtitle = "80% voll"
            mapView.addAnnotation(customPin)
    }
    
    @objc func presentMapDetailViewController() {
        let mapDetailViewController = MapDetailViewController()
        let nav = UINavigationController(rootViewController: mapDetailViewController)
        
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
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Custom")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(
                annotation: annotation,
                reuseIdentifier: "Custom"
            )
            annotationView?.canShowCallout = true
            
            
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(systemName: "leaf.circle")
        
        return annotationView
    }
}
