//
//  SearchViewController.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2020-03-19.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

/// Class for search restaurants according to location 
class SearchViewController: AbstractViewController {
    
    // MARK: IBOutlets for storyboard objects
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var locationManager: CLLocationManager! = nil
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Properties
    private var offset = 0
    private var limit = 20
    private var isPagesAvailable = false
    private let persistent = PersistenceManager.shared
    private var latitude: Double?
    private var longitude: Double?
    
    // MARK: Base model for items
    private var baseModel: BaseBusiness? = nil {
        didSet {
            guard let base = baseModel, let business = base.businesses, business.count > 0 else {
                return
            }
            guard let total = base.total else { return }
            isPagesAvailable = total > items.count
            items.append(contentsOf: base.businesses!)
        }
    }
    
    // MARK: Items array
    private var items: [Businesses] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.reloadTable()
            }
        }
    }
    
    // MARK: -  Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // get current location
        initLocation()
        // init views
        initViews()        
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
    
    // MARK: Init views and setup UI
    private func initViews() {
        initTableView()
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter location name"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: Reload tableview
    @objc private func reloadTable() {
        tableView.reloadData()
    }
    
    // MARK: Setup tableview & register cell
    private func initTableView() {
        tableView.register(UINib(nibName: cellClass.reuseId, bundle: nil), forCellReuseIdentifier: cellClass.reuseId)
        tableView.tableFooterView = UIView()
    }
    
    // MARK: Request for next page 
    private func requestForNextPage() {
        offset += limit
        fetchList()
    }
    
    // MARK: Fetching list 
    private func fetchList() {
        guard let lat = latitude, let lng = longitude else { return }
        let location = CLLocation(latitude: lat, longitude: lng)
        getLocationName(location: location)
    }
    
    // MARK: Reverse geocode to get location name from coordinates
    private func getLocationName(location: CLLocation)  {
        weak var `self` = self
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                debugPrint(error)
            } else {
                if let placemark = placemarks?[0] {
                    if (placemark.locality != nil) {
                        guard let `self` = self else { return }
                        let place = placemark.locality ?? "Toronto"
                        self.requestForRestaurants(with: place)
                    }
                }
            }
        }
    }
    
    // MARK: Request from YELPManager class
    private func requestForRestaurants(with name: String) {
        self.indicator.startAnimating()
        weak var `self` = self
        YelpManager.fetchYelpBusinesses(with: offset, location: name) { (baseModel) in
            guard let `self` = self else { return }
            self.indicator.stopAnimating()
            self.baseModel = baseModel
        }
    }
    
    // MARK: Get Cell class from type of cell
    private var cellClass: SearchTableViewCell.Type {
        return SearchTableViewCell.self
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

// MARK: Manage tableview delegates and data source
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellClass.reuseId, for: indexPath) as? SearchTableViewCell)!
        cell.business = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if items.count > 0 {
            let lastItemReached = indexPath.item == items.count - 1
            if isPagesAvailable && lastItemReached {
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else {
                        return
                    }
                    self.requestForNextPage()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellClass.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(MapViewController.controlWith(business: items[indexPath.row]), animated: true)
    }
}

/*
 Manage search bar delegates
 */
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let location = searchBar.text else { return }
        weak var `self` = self
        offset = 0
        indicator.startAnimating()
        YelpManager.fetchYelpBusinesses(with: offset, location: location) { (baseModel) in
            guard let `self` = self else { return }
            self.indicator.stopAnimating()
            self.items.removeAll()
            self.baseModel = baseModel
        }
    }
}

// MARK: - CLLocationManagerDelegates
typealias CLLocatiionDelegate = SearchViewController
extension CLLocatiionDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            guard latitude == nil && longitude == nil else { return }
            messageLabel.isHidden = true
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            // fetching data according to location
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) { 
                self.fetchList()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        items.removeAll()
        offset = 0
        reloadTable()
        messageLabel.isHidden = false
        messageLabel.text = error.localizedDescription
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        latitude = nil
        longitude = nil
        checkLocationAuthorizationStatus(status: status)
    }
}
