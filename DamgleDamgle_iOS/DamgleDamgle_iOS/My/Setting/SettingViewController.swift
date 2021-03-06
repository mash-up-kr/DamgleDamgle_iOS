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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePushSwitch()
    }
    
    private func updatePushSwitch() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async { [weak self] in
                // TODO: 서버 값이랑 동기화 할지? 로컬이랑 동기화 할지?
                self?.pushSwitch.isOn = settings.authorizationStatus == .authorized
            }
        }
    }
    
    private func resignService() {
        UserManager.shared.removeAccessToken()
        showNicknameViewController()
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
    
    @IBAction private func didTapSwitchValue(_ sender: UISwitch) {
        // TODO: 권한 재 요청?
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge],
            completionHandler: { [weak self] didAllow, error in
                DispatchQueue.main.async {
                    if didAllow {
                        // TODO: 서버 푸시 on
                        self?.pushSwitch.isOn = true
                    } else {
                        // TODO: 서버 푸시 off, 아래 에러가 어떤 에러인지 모르겠음. 알럿이 필요한지 확인 필요
                        self?.pushSwitch.isOn = false
                        if let errorMessage = error?.localizedDescription {
                            self?.showAlertController(
                                type: .single,
                                title: "에러가 발생했어요! 마이 페이지에서 푸시 권한 설정을 다시 설정해주세요.",
                                message: errorMessage
                            )
                        }
                    }
                }
            }
        )
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
    }
}
