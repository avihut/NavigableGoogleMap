//
//  ViewController.swift
//  NavigableGoogleMap
//
//  Created by Avihu Turzion on 10/03/2018.
//  Copyright © 2018 Avihu Turzion. All rights reserved.
//

import GoogleMaps
import UIKit

private let defaultZoomLevel: Float = 18

class ViewController: UIViewController {
    
    @IBOutlet private weak var mapView: GMSMapView!
    @IBOutlet private weak var searchFieldContainer: UIView!
    @IBOutlet private weak var locationSearchField: UITextField!
    
    private let locationManager = CLLocationManager()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupSearchFieldContainer()
        setupLocationServices()
    }
}

// MARK: - Internal

private extension ViewController {
    private func setupSearchFieldContainer() {
        searchFieldContainer.layer.shadowColor = UIColor.black.cgColor
        searchFieldContainer.layer.shadowOpacity = 0.2
        searchFieldContainer.layer.shadowRadius = 5.0
        searchFieldContainer.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
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

// MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
}

// MARK: - GMSMapViewDelegate

extension ViewController: GMSMapViewDelegate {
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        guard let coordinate = locationManager.location?.coordinate else { return false }
        mapView.animate(to: GMSCameraPosition.camera(withTarget: coordinate, zoom: defaultZoomLevel))
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        guard locationSearchField.isFirstResponder else { return }
        locationSearchField.resignFirstResponder()
    }
}

// MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        mapView.camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: defaultZoomLevel)
        manager.stopUpdatingLocation()
    }
}
