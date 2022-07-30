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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didMoveToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        locationManager.dataDelegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        locationManager.dataDelegate = nil
    }
    
// MARK: - objc
    @objc
    private func didMoveToForeground() {
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
            let pushAuthorizationViewController = PushAuthorizationViewController()
            pushAuthorizationViewController.modalPresentationStyle = .overFullScreen
            present(pushAuthorizationViewController, animated: true)
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
