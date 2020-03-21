//
//  MapViewController.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2020-03-20.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//

import UIKit
import GoogleMaps

/// Class responsible for showing google map to show path between current location and destination
class MapViewController: AbstractViewController, GMSMapViewDelegate {
    
    private var locationManager: CLLocationManager! = nil
    private var mapView: GMSMapView! = nil
    private var business: Businesses?
    private var userLocation: Coordinates?
    
    // MARK: Initialize mapview
    override func loadView() {
        let camera = GMSCameraPosition()
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        view = mapView
    }
    
    class func controlWith(business: Businesses) -> MapViewController {
        let control = self.control as! MapViewController
        control.business = business
        return control
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocation()
    }
    
    // MARK: Show marker for selected restaurant
    private func showMarker() {
        guard let business = business, let location = business.coordinates, let lat = location.latitude, let lng = location.longitude else { return }
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        marker.title = business.name
        if let location = business.location, let address =  location.address1, let city =  location.city{
            marker.snippet = "\(address), \(city)"
        }
        marker.map = mapView
        // fetch directions
        fetchDirections(from: Coordinates(latitude: lat, longitude: lng))
    }
    
    // MARK: Fetching directions from google api
    private func fetchDirections(from destination: Coordinates) {
        guard let userLocation = userLocation else { return } 
        GoogleAPIManager.fetchDirections(from: userLocation, to: destination) { (base) in
            guard let baseModel = base, let routes = baseModel.routes else { return }
            for route in routes {
                let routeOverviewPolyline = route.overview_polyline
                let points = routeOverviewPolyline?.points
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline(path: path)
                polyline.strokeColor = UIColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.00)
                polyline.strokeWidth = 2.0
                polyline.map = self.mapView
            }
        }
    }
    
    // MARK: Init CLLocatiion manager to fetch user location
    private func initLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let authStatus = CLLocationManager.authorizationStatus()
        checkLocationAuthorizationStatus(status: authStatus)
    }
    
    // MARK: checkLocationAuthorizationStatus 
    func checkLocationAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied:
            showLocationDisabledPopUp()
        case .restricted:
            UIAlertController.showAlert("Error", "Access to Location Services is Restricted", in: self)
        @unknown default:
            fatalError()
        }
    }
    
    // MARK: - Show alert while location is disabled
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background location access disabled", message: "We need your location access to get restaurants near you.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        alertController.addAction(openAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - CLLocationManagerDelegates
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userLocation = Coordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 10.0)
            mapView?.animate(to: camera)
            showMarker()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorizationStatus(status: status)
    }
}
