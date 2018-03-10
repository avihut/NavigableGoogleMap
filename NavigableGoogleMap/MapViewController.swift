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

class MapViewController: UIViewController {
    
    @IBOutlet private weak var mapView: GMSMapView!
    
    @IBOutlet private weak var searchFieldContainer: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var menuButton: UIButton!
    @IBOutlet private weak var locationSearchField: UITextField!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var directionsButton: UIButton!
    
    @IBOutlet private weak var locationSearchFieldCompactedConstraint: NSLayoutConstraint!
    @IBOutlet private weak var locationSearchFieldFullViewConstraint: NSLayoutConstraint!
    
    private let locationManager = CLLocationManager()
    
    private var isTypingSearchField = false {
        didSet {
            switch isTypingSearchField {
            case true: transitionToTypingSearchField()
            case false: transitionToNormalView()
            }
        }
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupSearchFieldContainer()
        setupLocationServices()
    }
    
    @IBAction func backButtonTapped() {
        isTypingSearchField = false
    }
}

// MARK: - Internal

private extension MapViewController {
    
    // MARK: Setup
    
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
    
    private func setupMapView() {
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
    }
    
    // MARK: Locations
    
    private func searchLocation() {
        isTypingSearchField = false
    }
    
    // MARK: Transitions
    
    private func transitionToTypingSearchField() {
        backButton.alpha = 0
        backButton.isHidden = false
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.backButton.alpha = 1.0
            self?.menuButton.alpha = 0
            self?.separatorView.alpha = 0
            self?.directionsButton.alpha = 0
            self?.locationSearchFieldFullViewConstraint.isActive = true
            self?.locationSearchFieldCompactedConstraint.isActive = false
            self?.view.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.menuButton.isHidden = true
            self?.separatorView.isHidden = true
            self?.directionsButton.isHidden = true
        })
    }
    
    private func transitionToNormalView() {
        locationSearchField.resignFirstResponder()
        separatorView.alpha = 0
        separatorView.isHidden = false
        directionsButton.alpha = 0
        directionsButton.isHidden = false
        menuButton.alpha = 0
        menuButton.isHidden = false
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.menuButton.alpha = 1.0
            self?.backButton.alpha = 0
            self?.separatorView.alpha = 1.0
            self?.directionsButton.alpha = 1.0
            self?.locationSearchFieldFullViewConstraint.isActive = false
            self?.locationSearchFieldCompactedConstraint.isActive = true
            self?.view.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.backButton.isHidden = true
        })
    }
}

// MARK: - UITextFieldDelegate

extension MapViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchLocation()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isTypingSearchField = true
        return true
    }
}

// MARK: - GMSMapViewDelegate

extension MapViewController: GMSMapViewDelegate {
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        guard let coordinate = locationManager.location?.coordinate else { return false }
        mapView.animate(to: GMSCameraPosition.camera(withTarget: coordinate, zoom: defaultZoomLevel))
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        guard locationSearchField.isFirstResponder else { return }
        isTypingSearchField = false
    }
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        mapView.camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: defaultZoomLevel)
        manager.stopUpdatingLocation()
    }
}
