//
//  LocationViewController.swift
//  JoinMeApp
//
//  Created by Jose Ricardo Arriaza on 8/6/24.
//

import UIKit
import MapKit
import CoreData
import FirebaseAuth

class LocationViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    var currentUser: NSManagedObject?
    var delegate: UIViewController?
    @IBOutlet weak var mapType: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    var postList:[PostClass] = []
    let geocoder = CLGeocoder()
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    var eventDistances:[String] = []
    let annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.layer.cornerRadius = 40 // Adjust the radius as needed
        mapView.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        delegate?.dismiss(animated: false)
        
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    ////        if let homeDelegate = delegate {
    ////            homeDelegate.dismiss(animated: true)
    ////        }
    //        super.viewDidAppear(true)
    //        delegate?.dismiss(animated: false)
    //    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeSegue",
            let destination = segue.destination as? UINavViewController{
            destination.locationDelegate = self
        } else if segue.identifier == "locationToUploadSegue",
                  let destination = segue.destination as? UploadPostViewController{
            destination.delegate = delegate
            destination.currentUser = currentUser
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let location = userLocation.location else { return }
        let center = location.coordinate
        let NS = 20000.0 // 15 km
        let EW = 20000.0 // 15 km
        let region = MKCoordinateRegion(center: center, latitudinalMeters: NS, longitudinalMeters: EW)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func mapChange(_ sender: Any) {
        switch mapType.selectedSegmentIndex {
        case 2:
            mapView.mapType = .satellite
        case 1:
            mapView.mapType = .hybrid
        default:
            mapView.mapType = .standard
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationTableViewCell
        let row = indexPath.row
        let post = postList[row]
       
        if Auth.auth().currentUser?.email!.replacingOccurrences(of: "@joinme.com", with: "").lowercased() == post.username.lowercased() {
            print("here")
            cell.nameLabel.text = "You: \(post.eventTitle)"
        } else {
            cell.nameLabel.text = "\(post.username.replacingOccurrences(of: "@joinme.com", with: "")): \(post.eventTitle)"
        }
        cell.addressLabel.text = post.location
        cell.addressLabel.textColor = .lightGray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = postList[indexPath.row]
        highlightAddress(post.location, mapView: mapView, post.eventTitle)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func highlightAddress(_ address: String, mapView: MKMapView, _ titleEvent:String) {
        geocoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
                
            if let placemark = placemarks?.first, let location = placemark.location {
                let coordinate = location.coordinate
                mapView.removeAnnotation(annotation)
                annotation.coordinate = coordinate
                annotation.title = titleEvent
                mapView.addAnnotation(annotation)
                // Center the map on the found location
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                mapView.setRegion(region, animated: true)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
        tableView.reloadData()
    }
}

