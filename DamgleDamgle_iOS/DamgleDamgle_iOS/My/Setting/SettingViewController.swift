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
        // TODO: 아이디 삭제
        // TODO: 첫 화면으로 이동시키기
        debugPrint("아이디 삭제 ⛔️")
    }
    
    @IBAction private func didTapSwitchValue(_ sender: UISwitch) {
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
