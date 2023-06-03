//
//  HomeViewController.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/12.
//

import NMapsMap
import UIKit
import Lottie
import CoreLocation

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
        mapView.minZoomLevel = 10
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
    private let postViewShortRatio = 0.86
    private let postViewLongRatio = 0.878
    private let originWidth: CGFloat = UIScreen.main.bounds.width
    private let originHeight: CGFloat = UIScreen.main.bounds.height
    
    private var timerType: DateIntervalType?
    private var timeValue: Int = 0 {
        didSet {
            updateTimer()
        }
    }
    
    private var timer: Timer?
    
    private let lottieSize = UIScreen.main.bounds.width * 0.35
    
    private let viewModel = HomeViewModel()
    private var mapViewMarkerList: [NMFMarker] = []
    private var isFirstShow = true
    
    private let postViewController = PostViewController()
    private let fullDimView = FullDimView()
    private let refreshLottieName = "refreshLottie"
    private lazy var animationView = Lottie.AnimationView(name: refreshLottieName)
    
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
        
        if children.isEmpty {
            setChildPostView()
        }
        
        if isFirstShow {
            locationManager.checkLocationServiceAuthorization()
            getCurrentLocationAddress()
            isFirstShow.toggle()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.dataDelegate = nil
        locationManager.locationDelegate = nil
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
// MARK: - @IBAction
    @IBAction private func myPageButtonTapped(_ sender: UIButton) {
        let myViewController = MyViewController.instantiate()
        myViewController.modalPresentationStyle = .overFullScreen
        present(myViewController, animated: true)
    }
    
    @IBAction private func refreshButtonTapped(_ sender: UIButton) {
        playLoadingLottie()
        
        viewModel.currentBoundary = mapView.coveringBounds
        
        viewModel.getStoryFeed { result in
            switch result {
            case .success(let homeModel):
                guard let homeModel = homeModel else { return }
                self.addMarker(homeModel: homeModel)
                self.stopLoadingLottie()
            case .failure(let error):
                // TODO: 에러 핸들링
                debugPrint("getStoryFeed", error)
            }
        }
    }
    
    @IBAction private func currentLocationButtonTapped(_ sender: UIButton) {
        let currentStatus = locationManager.currentStatus
        
        switch currentStatus {
        case .authorizationDenied, .locationServiceDisabled:
            showDefaultLocation()
        case .success:
            locationManager.startUpdatingCurrentLocation()
        default:
            break
        }
    }
    
    @IBAction private func paintViewDidTap(_ sender: UITapGestureRecognizer) {
        showAlertController(
            type: .single,
            title: "이번달 페인트칠이란?",
            message: """
            매월 마지막날,  담벼락을 새로
            페인트칠하면 모든 담글이 깨끗히 지워져요.
            해당 타이머를 보고 다음 페인트칠까지
            남은 시간을 확인하세요.
            """
        )
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
        setupLottieView()
    }
    
    func setupLottieView() {
        let screenSize = UIScreen.main.bounds
        let lottieSize = screenSize.width * 0.35

        view.addSubview(fullDimView)

        fullDimView.alpha = 0
        fullDimView.frame = view.bounds
        fullDimView.addSubview(animationView)
        
        animationView.frame = CGRect(
            x: (screenSize.width - lottieSize) / 2,
            y: (screenSize.height - lottieSize) / 2,
            width: lottieSize,
            height: lottieSize
        )
        
        animationView.contentMode = .scaleAspectFill
        animationView.isUserInteractionEnabled = false
    }
    
    private func addMapView() {
        mapView.frame = view.frame
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
        
        mapView.addCameraDelegate(delegate: self)

    }
    
    private func setChildPostView() {
        view.addSubview(postViewController.view)
        postViewController.view.frame = CGRect(
            x: 0,
            y: originHeight * postViewShortRatio,
            width: originWidth,
            height: originHeight * postViewLongRatio
        )
        addChild(postViewController)
        postViewController.didMove(toParent: self)
        postViewController.delegate = self
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
        
        GeocodingService.reverseGeocoding(request: request) { [weak self] result in
            switch result {
            case .success(let address):
                self?.currentAddressLabel.text = "\(address[0]) \(address[1])"
            case .failure(_):
                self?.getCurrentLocationAddress(
                    byCLLocationLatitude: self?.locationManager.currentLocation.latitude ?? .zero,
                    Longtitude: self?.locationManager.currentLocation.longitude ?? .zero
                )
            }
        }
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
                    self.currentAddressLabel.text = "\(address1) \(address2)"
                } else if count >= 1 {
                    let address1 = addressString.removeFirst()
                    self.currentAddressLabel.text = "\(address1) 담글이네"
                } else {
                    self.currentAddressLabel.text = "담글이네 찾는 중"
                }
                
            } else {
                self.currentAddressLabel.text = "담글이네 찾는 중"
            }
        }
    }
    
    private func removeMarkers() {
        self.mapViewMarkerList.forEach { marker in
            marker.mapView = nil
        }
        
        self.mapViewMarkerList = []
    }
    
    private func createMarker(markerData: Marker) -> NMFMarker {
        let marker = NMFMarker()
        
        let markerImage = createCustomMarkerView(markerData: markerData)
        marker.iconImage = markerImage
        marker.position = NMGLatLng(lat: markerData.markerPosition.latitude, lng: markerData.markerPosition.longitude)
        marker.mapView = self.mapView
        
        let handler = { [weak self] (overlay: NMFOverlay) -> Bool in
            let postingMainNavigationViewController = PostingNavigationController.instantiate()
            let postingMainViewController = postingMainNavigationViewController.viewControllers.first as? PostingMainViewController
//            postingMainViewController?.viewModel.currentBoundary = markerData.boundary
            postingMainViewController?.setMapCurrentBoundary(with: markerData.boundary)
//            postingMainViewController?.storyType = .allStory
            postingMainViewController?.setStoryType(with: .allStory)
//            postingMainNavigationViewController.modalPresentationStyle = .fullScreen
            self?.present(postingMainNavigationViewController, animated: true)
            return true
        }
        marker.touchHandler = handler
        
        return marker
    }
    
    private func createCustomMarkerView(markerData: Marker) -> NMFOverlayImage {
        let customMarkerView = CustomMarker(frame: CGRect(x: 0, y: 0, width: 68, height: 59))
        
        customMarkerView.updateMarker(
            markerType: markerData.isMine == true ? .my : .notMy,
            iconType: markerData.mainIcon,
            storyCount: markerData.storyCount
        )
        
        let customMarkerImage = customMarkerView.asImage()
        let customOverlayMarkerImage = NMFOverlayImage(image: customMarkerImage)
        
        return customOverlayMarkerImage
    }
    
    private func addMarker(homeModel: HomeModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.removeMarkers()
            
            homeModel.markerList.forEach { markerData in
                let customMarker = self.createMarker(markerData: markerData)
                self.mapViewMarkerList.append(customMarker)
            }
        }
    }
    
    private func playLoadingLottie() {
        fullDimView.backgroundColor = UIColor(named: "dimViewColor")
        animationView.play()
        
        UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) { [weak self] in
            self?.fullDimView.alpha = 1.0
        }.startAnimation()
    }
    
    private func stopLoadingLottie() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) { [weak self] in
                self?.fullDimView.alpha = 0
            }.startAnimation()
            
            self?.animationView.stop()
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
        locationManager.stopUpdatingCurrentLocation()
        
        let mapPosition = NMGLatLng(from: location)
        
        currentLocationMarker.zIndex = -100
        currentLocationMarker.position = mapPosition
        currentLocationMarker.mapView = mapView
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: mapPosition, zoomTo: defaultZoomLevel)
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 0.5
        mapView.moveCamera(cameraUpdate)
        
        getCurrentLocationAddress()
    }
}

extension HomeViewController: NMFMapViewCameraDelegate {
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        viewModel.currentBoundary = mapView.coveringBounds
        
        viewModel.getStoryFeed { result in
            switch result {
            case .success(let homeModel):
                guard let homeModel = homeModel else { return }
                self.addMarker(homeModel: homeModel)
            case .failure(let error):
                self.showAlertController(
                    type: .single,
                    title: "오류 발생",
                    message: error.localizedDescription,
                    okActionTitle: "확인"
                )
            }
        }
    }
}

extension HomeViewController: DimViewDelegate {
    func postViewSwipeDidChange(_ direction: UISwipeGestureRecognizer.Direction) {
        fullDimView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        switch direction {
        case .up:
            UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) { [weak self] in
                self?.fullDimView.alpha = 1
            }.startAnimation()
        case .down:
            UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) { [weak self] in
                self?.fullDimView.alpha = 0
            }.startAnimation()
        default:
            break
        }
    }
}
