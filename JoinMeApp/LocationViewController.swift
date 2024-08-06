//
//  LocationViewController.swift
//  JoinMeApp
//
//  Created by Jose Ricardo Arriaza on 8/6/24.
//

import UIKit
import MapKit

class LocationViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var nearbyList:[Post] = []
    @IBOutlet weak var mapType: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.layer.cornerRadius = 40 // Adjust the radius as needed
        mapView.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let location = userLocation.location else { return }
        let center = location.coordinate
        let NS = 15000.0 // 15 km
        let EW = 15000.0 // 15 km
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
        return nearbyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationTableViewCell
        return cell
    }
}
