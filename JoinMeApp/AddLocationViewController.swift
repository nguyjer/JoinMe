//
//  AddLocationViewController.swift
//  JoinMeApp
//
//  Created by Jose Ricardo Arriaza on 8/14/24.
//

import UIKit
import MapKit
import CoreLocation

class AddLocationViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var selectedLocation: CLLocationCoordinate2D?
    var selectedAddress: String?
    var delegate: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        if #available(iOS 13.0, *) {
            mapView.pointOfInterestFilter = MKPointOfInterestFilter.includingAll
        }
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let location = userLocation.location else { return }
        let center = location.coordinate
        let NS = 5000.0 // 5 km
        let EW = 5000.0 // 5 km
        let region = MKCoordinateRegion(center: center, latitudinalMeters: NS, longitudinalMeters: EW)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func handleMapTap(gestureRecognizer: UITapGestureRecognizer) {
        
            let locationInView = gestureRecognizer.location(in: mapView)
            let tappedCoordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
            
            // Store the tapped location in a variable
            selectedLocation = tappedCoordinate
            
            //add a pin annotation to the map
            let annotation = MKPointAnnotation()
            annotation.coordinate = tappedCoordinate
            mapView.removeAnnotations(mapView.annotations) 
            // Remove previous annotations if needed
            mapView.addAnnotation(annotation)
            
            // Reverse geocode the coordinates to get the address
            let location = CLLocation(latitude: tappedCoordinate.latitude, longitude: tappedCoordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Reverse geocoding failed: \(error.localizedDescription)")
                    return
                }
                
                if let placemark = placemarks?.first {
                    let address = self.formatAddress(from: placemark)
                    self.selectedAddress = address
                    let otherVC = self.delegate as! getInfo
                    otherVC.addedLocation(selected: self.selectedAddress!)
                    
                    //adds a two second delay for dismissing after pinning event location
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                self.dismiss(animated: true, completion: nil)
                            }
                }
            }
        }
        
        // Helper function to format the address from the placemark
    func formatAddress(from placemark: CLPlacemark) -> String {
        var addressString = ""
        
        if let name = placemark.name {
            addressString += name + ", "
        }
        if let locality = placemark.locality {
            addressString += locality + ", "
        }
        if let administrativeArea = placemark.administrativeArea {
            addressString += administrativeArea
        }
        return addressString
    }
}
