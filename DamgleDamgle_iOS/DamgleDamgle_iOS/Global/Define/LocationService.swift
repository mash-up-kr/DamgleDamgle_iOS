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

final class LocationService: NSObject, CLLocationManagerDelegate {
    static let shared: LocationService = LocationService()
    
    weak var delegate: LocationDataProtocol?
    
    private let manager: CLLocationManager = CLLocationManager()

    // 추후 사용예정
    var currentLocation: CLLocation?
    
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
        delegate?.updateCurrentStatus(.locationUpdateFail)
    }
    
// MARK: - UDF
    func checkLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus = manager.authorizationStatus
        
        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization(authorizationStatus)
        } else {
            delegate?.updateCurrentStatus(.locationServiceDisabled)
        }
    }
    
    func checkCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            delegate?.updateCurrentStatus(.authorizationDenied)
        case .authorizedAlways, .authorizedWhenInUse:
            delegate?.updateCurrentStatus(.success)
        @unknown default:
            break
        }
    }
}
