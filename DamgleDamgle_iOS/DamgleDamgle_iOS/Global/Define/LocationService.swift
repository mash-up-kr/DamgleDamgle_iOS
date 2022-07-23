//
//  LocationService.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/06.
//

import CoreLocation
import Foundation

protocol LocationDataProtocol: AnyObject {
    func updateCurrentStatus(_ currentStatus: LocationAuthorizationStatus?)
}

protocol LocationUpdateProtocol: AnyObject {
    func updateCurrentLocation(location: CLLocation)
}

final class LocationService: NSObject, CLLocationManagerDelegate {
    static let shared: LocationService = LocationService()
    
    weak var dataDelegate: LocationDataProtocol?
    weak var locationDelegate: LocationUpdateProtocol?
    
    private let manager: CLLocationManager = CLLocationManager()

    var currentLocation: CLLocation = CLLocation() {
        didSet {
            locationDelegate?.updateCurrentLocation(location: currentLocation)
        }
    }
    
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
        currentLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        dataDelegate?.updateCurrentStatus(.locationUpdateFail)
    }
    
// MARK: - UDF
    func checkLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus = manager.authorizationStatus
        
        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization(authorizationStatus)
        } else {
            dataDelegate?.updateCurrentStatus(.locationServiceDisabled)
        }
    }
    
    func checkCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            dataDelegate?.updateCurrentStatus(.authorizationDenied)
        case .authorizedAlways, .authorizedWhenInUse:
            dataDelegate?.updateCurrentStatus(.success)
        @unknown default:
            break
        }
    }
    
    func startUpdatingCurrentLocation() {
        manager.startUpdatingLocation()
    }
}
