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
                switch result {
                case .success(let address):
                    self.currentAddress = address
                case .failure(_):
                    self.getCurrentLocationAddress(
                        byCLLocationLatitude: self.currentLocation.latitude,
                        Longtitude: self.currentLocation.longitude
                    )
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
    
    private func getCurrentLocationAddress(byCLLocationLatitude: Double, Longtitude: Double) {
        let findLocation = CLLocation(latitude: byCLLocationLatitude, longitude: Longtitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale) { placemarks, _ in
            if let address: [CLPlacemark] = placemarks {
                var addressString: [String] = [
                    address.first?.thoroughfare,
                    address.first?.subLocality,
                    address.first?.locality,
                    address.first?.subAdministrativeArea,
                    address.first?.administrativeArea,
                    address.first?.country
                ]
                    .compactMap { $0 }
                    .uniqued()
                
                let count = addressString.count

                if count >= 2 {
                    let address2 = addressString.removeFirst()
                    let address1 = addressString.removeFirst()
                    self.currentAddress = [address1, address2]
                } else if count >= 1 {
                    let address1 = addressString.removeFirst()
                    self.currentAddress = [address1, "담글이네"]
                } else {
                    self.currentAddress = ["담글이네", "찾는 중"]
                }
            } else {
                self.currentAddress = ["담글이네", "찾는 중"]
            }
        }
    }
}
