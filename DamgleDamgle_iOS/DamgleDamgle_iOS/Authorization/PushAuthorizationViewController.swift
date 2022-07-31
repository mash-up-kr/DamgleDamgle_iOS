//
//  LocationAuthorizationViewController.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/30.
//

import UIKit

final class PushAuthorizationViewController: UIViewController {    
    private let fullDimView: UIView = FullDimView()

// MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDimView()
        requestNotificationPermission()
    }
    
    private func setupDimView() {
        view.addSubview(fullDimView)
        fullDimView.frame = view.bounds
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge],
            completionHandler: { [weak self] didAllow, error in
                DispatchQueue.main.async {
                    if didAllow {
                        // TODO: 서버 푸시 on
                    } else {
                        // TODO: 서버 푸시 off, 아래 에러가 어떤 에러인지 모르겠음. 알럿이 필요한지 확인 필요
                        if let errorMessage = error?.localizedDescription {
                            self?.showAlertController(
                                type: .single,
                                title: "에러가 발생했어요! 마이 페이지에서 푸시 권한 설정을 다시 설정해주세요.",
                                message: errorMessage
                            )
                        }
                    }
                    self?.showNicknameViewController()
                }
            }
        )
    }
    
    private func showNicknameViewController() {
        let pushAuthorizationViewController = NicknameViewController.instantiate()
        pushAuthorizationViewController.modalPresentationStyle = .overFullScreen
        present(pushAuthorizationViewController, animated: true)
    }
}
