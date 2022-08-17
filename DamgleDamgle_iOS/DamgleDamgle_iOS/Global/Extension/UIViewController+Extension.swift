//
//  UIView+Extension.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/07.
//

import Lottie
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
    
    func addLottieAnimation(lottieName: String, lottieSize: CGFloat, isNeedDimView: Bool, completion: (() -> Void)? = nil) {
        let originWidth: CGFloat = UIScreen.main.bounds.width
        let originHeight: CGFloat = UIScreen.main.bounds.height
        var animationHandler: (() -> Void)?
        
        let animationView = Lottie.AnimationView(name: lottieName)
        animationView.frame = CGRect(
            x: (originWidth - lottieSize) / 2,
            y: (originHeight - lottieSize) / 2,
            width: lottieSize,
            height: lottieSize
        )
        animationView.contentMode = .scaleAspectFill
        animationView.isUserInteractionEnabled = false
        
        if isNeedDimView {
            let fullDimView = FullDimView()
            fullDimView.alpha = 0
            fullDimView.frame = CGRect(
                x: 0,
                y: 0,
                width: originWidth,
                height: originHeight
            )
            
            fullDimView.addSubview(animationView)
            view.addSubview(fullDimView)
            
            animationHandler = {
                animationView.removeFromSuperview()
                fullDimView.removeFromSuperview()
            }
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                fullDimView.alpha = 0.95
            }

        } else {
            view.addSubview(animationView)
            
            animationHandler = {
                animationView.removeFromSuperview()
            }
        }
        
        animationView.play { _ in
            DispatchQueue.main.async {
                UIView.transition(with: self.view, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    if let animationHandler = animationHandler {
                        animationHandler()
                    }
                    
                    if let completion = completion {
                        completion()
                    }
                })
            }
        }
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
                잠시 후에 다시 시도해주세요.
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
