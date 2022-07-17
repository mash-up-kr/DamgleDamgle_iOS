//
//  LocationAuthorizationViewController.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/06.
//

import UIKit

final class LocationAuthorizationViewController: UIViewController {
    @IBOutlet private weak var guideLabel: UILabel!
    
    private let fullDimView: UIView = FullDimView()
    private let locationManager: LocationService = LocationService.shared

// MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didMoveToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        layoutView()
        
        locationManager.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        locationManager.delegate = nil
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
// MARK: - objc
    @objc
    func didMoveToForeground() {
        locationManager.checkLocationServiceAuthorization()
    }
    
// MARK: - UDF
    func layoutView() {
        view.addSubview(fullDimView)
        fullDimView.frame = view.bounds
    }
    
    func checkCurrentStatus(currentStatus: LocationAuthorizationStatus?) {
        let title: String = "위치정보 이용에 대한 엑세스 권한이 없어요"
        let message: String = "설정으로 이동해서 권한을 변경해주세요!"
        
        switch currentStatus {
        case .authorizationDenied, .locationServiceDisabled:
            // 이렇게 파라미터가 많고 긴 함수를 사용할 때, 이렇게 한 줄 한 줄 나누는게 좋을지 간단한 파라미터는 한 줄에 쓰고 handler같은 파라미터만 줄 나눠서 쓰는게 좋을지 의견 부탁드려요!
            self.showAlertController(
                type: .single,
                title: title,
                message: message,
                okActionHandler: {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                })
        case .success:
            // TODO: push 권한 받는 뷰컨으로 이동
            break
        case .locationUpdateFail, .none:
            break
        }
    }
}

// MARK: - extension
extension LocationAuthorizationViewController: LocationDataProtocol {
    func updateCurrentStatus(_ currentStatus: LocationAuthorizationStatus?) {
        checkCurrentStatus(currentStatus: currentStatus)
    }
}
