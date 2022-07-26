//
//  UIView+Extension.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/07.
//

import UIKit

extension UIViewController {
    func showAlertController(type: AlertType, title: String, message: String, okActionTitle: String = "확인", okActionHandler: (() -> Void)? = nil, cancelActionTitle: String = "취소", cancelActionHandler: (() -> Void)? = nil) {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if type == .double {
            let cancelAction: UIAlertAction = UIAlertAction(title: cancelActionTitle, style: .default) { _ in
                if let cancelActionHandler = cancelActionHandler {
                    cancelActionHandler()
                }
            }
            alertController.addAction(cancelAction)
        }
        
        let okAction: UIAlertAction = UIAlertAction(title: okActionTitle, style: .default) { _ in
            if let okActionHandler = okActionHandler {
                okActionHandler()
            }
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController {
    enum AlertType {
        case single
        case double
    }
    
    enum PostStatus {
        case inProgress
        case success
        case fail
        
        var statusTitle: String {
            switch self {
            case .inProgress:
                return """
                지금 담벼락에
                나만의 글 남기는 중...
                """
            case .success:
                return """
                담벼락에
                나만의 글 남기기 완료!
                """
            case .fail:
                return """
                담벼락에
                담글 남기기 실패...
                """
            }
        }
        
        var subTitle: String {
            switch self {
            case .inProgress, .success:
                return ""
            case .fail:
                return """
                네트워크 오류 등으로 글남기기를 실패했어요.
                다음에 다시 시도해주세요.
                """
            }
        }
        
        var buttonTitle: String? {
            switch self {
            case .inProgress:
                return nil
            case .success:
                return "확인하러 가기"
            case .fail:
                return "다시 담글 남기러 가기"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .inProgress:
                return nil
            case .success:
                return UIImage(named: "post_success")
            case .fail:
                return UIImage(named: "post_fail")
            }
        }
    }
}
