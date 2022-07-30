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
    
    @IBAction private func changedPushSwitchValue(_ sender: UISwitch) {
        // TODO: 푸시 on/off 서버로 전송
        // TODO: on/off 성공 알럿창 띄워야하는지 확인
        debugPrint("push \(sender.isOn) ✅")
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
    
    private func resignService() {
        // TODO: 아이디 삭제
        // TODO: 첫 화면으로 이동시키기
        debugPrint("아이디 삭제 ⛔️")
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
