//
//  SettingViewController.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/16.
//

import UIKit

final class SettingViewController: UIViewController, StoryboardBased {
    static var storyboard: UIStoryboard {
        UIStoryboard(name: "My", bundle: nil)
    }
    
    @IBOutlet private weak var pushSwitch: UISwitch!
    @IBOutlet private weak var settingButton: UIButton!

    private let viewModel = SettingViewModel()
    
    var isAllowNotification: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updatePushSwitch()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForegroundNotification),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    private func updatePushSwitch() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async { [weak self] in
                self?.settingButton.isHidden = settings.authorizationStatus == .authorized
                self?.pushSwitch.isOn = self?.isAllowNotification == true
            }
        }
    }
    
    private func resignService() {
        viewModel.deleteMe { [weak self] error in
            if let error = error {
                self?.showAlertController(
                    type: .single,
                    title: Strings.resignFail,
                    message: error.localizedDescription,
                    okActionTitle: Strings.confirm,
                    okActionHandler: nil,
                    cancelActionTitle: "",
                    cancelActionHandler: nil
                )
            } else {
                UserManager.shared.removeAccessToken()
                self?.showNicknameViewController()
            }
        }
    }
    
    private func showNicknameViewController() {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }

        guard let keyWindow = keyWindow else {
            return
        }
        
        DispatchQueue.main.async {
            UIView.transition(with: keyWindow, duration: 0.3, options: .transitionCrossDissolve, animations: {
                let nicknameViewController = NicknameViewController.instantiate()
                keyWindow.rootViewController = nicknameViewController
            })
        }
    }

    @objc private func willEnterForegroundNotification() {
        updatePushSwitch()
    }
    
    @IBAction private func notificationSettingButtonDidTap() {
        showAlertController(
            type: .double,
            title: Strings.notificationSettingTitle,
            message: "",
            okActionTitle: Strings.moveToSetting,
            okActionHandler: {
                guard let url = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                UIApplication.shared.open(url)
            },
            cancelActionTitle: Strings.cancel,
            cancelActionHandler: nil
        )
    }
    
    @IBAction private func didTapSwitchValue(_ sender: UISwitch) {
        viewModel.patchNotify { [weak self] error in
            guard let self = self else {
                return
            }
            
            if let error = error {
                // TODO: error handling
                debugPrint(error.localizedDescription)
            } else {
                self.isAllowNotification = !self.isAllowNotification
                self.pushSwitch.isOn = self.isAllowNotification
            }
        }
    }
    
    @IBAction private func didTapResignButton(_ sender: UIButton) {
        showAlertController(
            type: .double,
            title: Strings.resignTitle,
            message: Strings.resignDescription,
            okActionTitle: Strings.resign,
            okActionHandler: { [weak self] in
                self?.resignService()
            },
            cancelActionTitle: Strings.cancelResign,
            cancelActionHandler: nil
        )
    }
}

extension SettingViewController {
    enum Strings {
        static let resignTitle = "정말 내 정보를 삭제하고 서비스를 그만 사용하실건가요?"
        static let resignDescription = "모든 계정 정보를 삭제하시면\n다시 되살릴 수 없어요!"
        static let resign = "삭제"
        static let cancelResign = "삭제 취소"
        static let notificationSettingTitle = "아이폰 기본 설정에서 알림을 켜주세요."
        static let moveToSetting = "설정으로 이동"
        static let cancel = "취소"
        static let confirm = "확인"
        static let resignFail = "현재 네트워크 문제로 서비스 그만두기가 불가해요. 나중에 다시 시도해주세요."
    }
}
