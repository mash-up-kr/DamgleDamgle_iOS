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
    
//    private enum MonthlyPaintingMode: String {
//        case moreThanOneHour = "grey1000"
//        case lessThanOneHour = "orange500"
//    }
    
    private var currentPaintingMode: DateIntervalType = .moreThanDay {
        didSet {
            monthlyPaintingBGView.backgroundColor = currentPaintingMode.backgroundColor
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
    private let postViewHeightRatio = 0.85
    private let originWidth: CGFloat = UIScreen.main.bounds.width
    private let originHeight: CGFloat = UIScreen.main.bounds.height
    
    private var timerType: DateIntervalType?
    private var timeValue: Int = 0 {
        didSet {
            updateTimer()
        }
    }
    
    private var timer: Timer?
    
// MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        addMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.dataDelegate = self
        locationManager.locationDelegate = self
        
        getLastDateOfMonth()
    }
    
// MARK: - override
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.checkLocationServiceAuthorization()
        
        if children.isEmpty {
            setChildPostView()
        }
    }
    
    func resetChildView() {
        if let childrenViewController = children.first as? PostViewController {
            childrenViewController.view.frame = CGRect(
                x: 0,
                y: originHeight * postViewHeightRatio,
                width: originWidth,
                height: originHeight * (1 - postViewHeightRatio)
            )
            childrenViewController.setUpView()
        }
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
        let childView: PostViewController = PostViewController()
        view.addSubview(childView.view)
        childView.view.frame = CGRect(
            x: 0,
            y: originHeight * postViewHeightRatio,
            width: originWidth,
            height: originHeight * (1 - postViewHeightRatio)
        )
        addChild(childView)
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

    func getLastDateOfMonth() {
//        let resut = Date().getIntervalTilLastDate()
//        currentPaintingMode = resut.0
//        timeValue = resut.1
        currentPaintingMode = .moreThanDay
        timeValue = 4
    }
    
    func updateTimer() {
        if timer != nil && timer!.isValid {
            timer?.invalidate()
        }
        
        switch currentPaintingMode {
        case .moreThanDay:
            monthlyPaintingRemainingTimeLabel.text = "D-\(timeValue)"
        case .betweenHourAndDay, .lessThanHour:
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        }
    }
    
    @objc
    func fire() {
        if timeValue <= 60 {
            currentPaintingMode = .lessThanHour
        }
        else if timeValue < 24 * 60 * 60 {
            currentPaintingMode = .betweenHourAndDay
        }
        
        let hour = (timeValue / 3600).intToStringWithZero
        let minute = ((timeValue % 3600) / 60).intToStringWithZero
        let second = (timeValue % 60).intToStringWithZero
        
        monthlyPaintingRemainingTimeLabel.text = "\(hour):\(minute):\(second)"
        timeValue -= 1
        
        
        if timeValue < 0 {
            timer?.invalidate()
        }
    }
}
