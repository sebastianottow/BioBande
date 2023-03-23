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


class MapViewController: UIViewController, MKMapViewDelegate {
    
    let mapView = MKMapView()
    
    private var longitude = CLLocationCoordinate2D().longitude
    private var latitude = CLLocationCoordinate2D().latitude
    
    let address = "1 Infinite Loop, Cupertino, CA 95014"

    fileprivate let locationManager: CLLocationManager = CLLocationManager()

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
                    self.longitude = location.coordinate.longitude
                    self.latitude = location.coordinate.latitude
                    
                    print("\nlat: \(self.latitude), long: \(self.longitude)")
                    
                    self.addCustomPin(latCoord: self.latitude, longCoord: self.longitude)
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
