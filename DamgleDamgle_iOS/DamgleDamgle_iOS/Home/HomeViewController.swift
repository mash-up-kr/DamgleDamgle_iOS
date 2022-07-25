//
//  HomeViewController.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/12.
//

import NMapsMap
import UIKit

final class HomeViewController: UIViewController {    
    @IBOutlet private weak var currentAddressLabel: UILabel!
    @IBOutlet private weak var monthlyPaintingBGView: UIView! {
        didSet {
            monthlyPaintingBGView.layer.cornerRadius = 8
        }
    }
    @IBOutlet private weak var monthlyPaintingRemainingTimeLabel: UILabel!
    
    private enum MonthlyPaintingMode: String {
        case moreThanOneHour = "grey1000"
        case lessThanOneHour = "orange500"
    }
    
    private var currentPaintingMode: MonthlyPaintingMode = .moreThanOneHour {
        didSet {
            monthlyPaintingBGView.backgroundColor = UIColor(named: currentPaintingMode.rawValue)
        }
    }
    
    private let locationManager: LocationService = LocationService.shared
    private var mapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.minZoomLevel = 14.8
        return mapView
    }()
    private var currentLocationMarker: NMFMarker = {
        let marker = NMFMarker()
        marker.iconImage = NMFOverlayImage(name: "btn_picker_me")
        return marker
    }()
    private let defaultZoomLevel = 15.5
    private var isFirstUpdate = true
    private let defaultLocation = CLLocationCoordinate2D(latitude: 37.56157, longitude: 126.9966302)
    
// MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        addMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.dataDelegate = self
        locationManager.locationDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setChildPostView()
        locationManager.checkLocationServiceAuthorization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.dataDelegate = nil
        locationManager.locationDelegate = nil
    }
    
// MARK: - @IBAction
    @IBAction private func myPageButtonTapped(_ sender: UIButton) {
        let myViewController = MyViewController.instantiate()
        myViewController.modalPresentationStyle = .overFullScreen
        present(myViewController, animated: true)
    }
    
    @IBAction private func refreshButtonTapped(_ sender: UIButton) {
        // TODO: 새로 고침
    }
    
    @IBAction private func currentLocationButtonTapped(_ sender: UIButton) {
        let currentStatus = locationManager.currentStatus
        
        switch currentStatus {
        case .authorizationDenied, .locationServiceDisabled:
            showDefaultLocation()
        case .success:
            let mapPosition = NMGLatLng(from: locationManager.currentLocation)
            mapView.moveCamera(NMFCameraUpdate(position: NMFCameraPosition(mapPosition, zoom: defaultZoomLevel)))
        default:
            break
        }
    }
    
// MARK: - objc
//    @objc
//    func didMoveToForeground() {
//
//    }
    
// MARK: - UDF
    private func addMapView() {
        mapView.frame = view.frame
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
    }
    
    private func setChildPostView() {
        let originWidth: CGFloat = UIScreen.main.bounds.width
        let originHeight: CGFloat = UIScreen.main.bounds.height
        
        let childView: PostViewController = PostViewController()
        view.addSubview(childView.view)
        childView.view.frame = CGRect(x: 0, y: originHeight * 0.85, width: originWidth, height: originHeight * 0.15)
        self.addChild(childView)
        
        childView.didMove(toParent: self)
    }
    
    private func checkCurrentStatus(currentStatus: LocationAuthorizationStatus?) {
        switch currentStatus {
        case .authorizationDenied, .locationServiceDisabled:
            showDefaultLocation()
        case .success:
            locationManager.startUpdatingCurrentLocation()
        case .locationUpdateFail, .none:
            break
        }
    }
    
    private func showDefaultLocation() {
        let mapPosition = NMGLatLng(from: defaultLocation)
        mapView.moveCamera(NMFCameraUpdate(position: NMFCameraPosition(mapPosition, zoom: defaultZoomLevel)))
        
        showAlertController(
            type: .single,
            title: CommonStringResource.noLocationAuthorization.title,
            message: CommonStringResource.noLocationAuthorization.message,
            okActionHandler: {
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }

                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        )
    }
}

extension HomeViewController: LocationDataProtocol {
    func updateCurrentStatus(_ currentStatus: LocationAuthorizationStatus?) {
        checkCurrentStatus(currentStatus: currentStatus)
    }
}

extension HomeViewController: LocationUpdateProtocol {
    func updateCurrentLocation(location: CLLocationCoordinate2D) {
        let mapPosition = NMGLatLng(from: location)

        currentLocationMarker.position = mapPosition
        currentLocationMarker.mapView = mapView
        
        if isFirstUpdate {
            mapView.moveCamera(NMFCameraUpdate(position: NMFCameraPosition(mapPosition, zoom: defaultZoomLevel)))
            isFirstUpdate = false
        }
    }
}
