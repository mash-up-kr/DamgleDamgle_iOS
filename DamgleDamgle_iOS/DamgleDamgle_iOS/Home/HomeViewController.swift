//
//  HomeViewController.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/12.
//

import NMapsMap
import UIKit
import Lottie

final class HomeViewController: UIViewController {    
    @IBOutlet private weak var currentAddressLabel: UILabel!
    @IBOutlet private weak var monthlyPaintingBGView: UIView! {
        didSet {
            monthlyPaintingBGView.layer.cornerRadius = 8
        }
    }
    @IBOutlet private weak var monthlyPaintingRemainingTimeLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
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
    
    private let refreshLottieName = "refreshLottie"
    private let lottieSize = UIScreen.main.bounds.width * 0.35
    
// MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        addMapView()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.dataDelegate = self
        locationManager.locationDelegate = self
        
        getLastDateOfMonth()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didMoveToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.checkLocationServiceAuthorization()
        
        if children.isEmpty {
            setChildPostView()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.dataDelegate = nil
        locationManager.locationDelegate = nil
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
// MARK: - @IBAction
    @IBAction private func myPageButtonTapped(_ sender: UIButton) {
        let myViewController = MyViewController.instantiate()
        myViewController.modalPresentationStyle = .overFullScreen
        present(myViewController, animated: true)
    }
    
    @IBAction private func refreshButtonTapped(_ sender: UIButton) {
        // TODO: 새로 고침
        addLottieAnimation(
            lottieName: refreshLottieName,
            lottieSize: lottieSize,
            isNeedDimView: true
        )
    }
    
    @IBAction private func currentLocationButtonTapped(_ sender: UIButton) {
        let currentStatus = locationManager.currentStatus
        
        switch currentStatus {
        case .authorizationDenied, .locationServiceDisabled:
            showDefaultLocation()
        case .success:
            let mapPosition = NMGLatLng(from: locationManager.currentLocation)
            mapView.moveCamera(NMFCameraUpdate(position: NMFCameraPosition(mapPosition, zoom: defaultZoomLevel)))
            getCurrentLocationAddress()
        default:
            break
        }
    }
    
    @IBAction func moveToListView(_ sender: UIButton) {
        let postingMainViewController = PostingNavigationController.instantiate()
        postingMainViewController.modalPresentationStyle = .overFullScreen
        present(postingMainViewController, animated: true)
    }
    
// MARK: - objc
    @objc
    private func didMoveToForeground() {
        getLastDateOfMonth()
    }
    
    @objc
    private func resetTimer() {
        if timeValue <= Date.hourInSec {
            currentPaintingMode = .lessThanHour
        } else if timeValue < Date.dateInSec {
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
    
// MARK: - UDF
    private func setupView() {
        currentAddressLabel.text = ""
    }
    
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
    
    private func getLastDateOfMonth() {
        let currentIntervalTypeAndValue = Date().getDateIntervalType()
        currentPaintingMode = currentIntervalTypeAndValue.type
        timeValue = currentIntervalTypeAndValue.value
    }
    
    private func updateTimer() {
        if timer != nil && timer!.isValid {
            timer?.invalidate()
        }
        
        switch currentPaintingMode {
        case .moreThanDay:
            monthlyPaintingRemainingTimeLabel.text = "D-\(timeValue)"
        case .betweenHourAndDay, .lessThanHour:
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(resetTimer), userInfo: nil, repeats: true)
        }
    }
    
    private func getCurrentLocationAddress() {
        let request = GeocodingRequest(
            lat: locationManager.currentLocation.latitude,
            lng: locationManager.currentLocation.longitude
        )
        
        GeocodingService.reverseGeocoding(request: request) { result in
            switch result {
            case .success(let address):
                self.currentAddressLabel.text = address
            case .failure(let error):
                self.currentAddressLabel.text = ""
            }
        }
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
            getCurrentLocationAddress()
            mapView.moveCamera(NMFCameraUpdate(position: NMFCameraPosition(mapPosition, zoom: defaultZoomLevel)))
            isFirstUpdate = false
        }
    }
}
