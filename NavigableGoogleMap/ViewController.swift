//
//  ViewController.swift
//  NavigableGoogleMap
//
//  Created by Avihu Turzion on 10/03/2018.
//  Copyright © 2018 Avihu Turzion. All rights reserved.
//

import GoogleMaps
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var mapView: GMSMapView!
    
    private let locationManager = CLLocationManager()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupLocationServices()
    }
}

private extension ViewController {
    private func setupLocationServices() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setupMapView() {
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
    }
}

extension ViewController: GMSMapViewDelegate {
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        guard let coordinate = locationManager.location?.coordinate else { return false }
        mapView.animate(to: GMSCameraPosition.camera(withTarget: coordinate, zoom: 18.0))
        return true
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        mapView.camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 18.0)
        manager.stopUpdatingLocation()
    }
}
