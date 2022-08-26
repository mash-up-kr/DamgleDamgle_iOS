//
//  LocationService.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/06.
//

import CoreLocation
import Foundation
import NMapsMap

protocol LocationDataProtocol: AnyObject {
    func updateCurrentStatus(_ currentStatus: LocationAuthorizationStatus?)
}

protocol LocationUpdateProtocol: AnyObject {
    func updateCurrentLocation(location: CLLocationCoordinate2D)
}

final class LocationService: NSObject, CLLocationManagerDelegate {
    static let shared: LocationService = LocationService()
    
    weak var dataDelegate: LocationDataProtocol?
    weak var locationDelegate: LocationUpdateProtocol?
    
    private let manager: CLLocationManager = CLLocationManager()

    var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D() {
        didSet {
            locationDelegate?.updateCurrentLocation(location: currentLocation)
            
            let geocodingRequest = GeocodingRequest(lat: currentLocation.latitude, lng: currentLocation.longitude)
            GeocodingService.reverseGeocoding(request: geocodingRequest) { result in
                if case let .success(address) = result {
                    self.currentAddress = address
                }
            }
        }
    }
    
    var currentStatus: LocationAuthorizationStatus? {
        didSet {
            dataDelegate?.updateCurrentStatus(currentStatus)
        }
    }
    
    var currentAddress: [String] = []
    
    override private init() {
        super.init()
        manager.delegate = self
    }
    
// MARK: - Delegate
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationServiceAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        currentStatus = .locationUpdateFail
    }
    
// MARK: - UDF
    func checkLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus = manager.authorizationStatus
        
        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization(authorizationStatus)
        } else {
            currentStatus = .locationServiceDisabled
        }
    }
    
    func checkCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            currentStatus = .authorizationDenied
        case .authorizedWhenInUse, .authorizedAlways:
            currentStatus = .success
        }
    }
    
    func startUpdatingCurrentLocation() {
        manager.startUpdatingLocation()
    }
    
    func stopUpdatingCurrentLocation() {
        manager.stopUpdatingLocation()
    }
}
