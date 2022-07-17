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
        let okAction: UIAlertAction = UIAlertAction(title: okActionTitle, style: .default) { _ in
            if let okActionHandler = okActionHandler {
                okActionHandler()
            }
        }
        alertController.addAction(okAction)
        
        if type == .double {
            let cancelAction: UIAlertAction = UIAlertAction(title: cancelActionTitle, style: .cancel) { _ in
                if let cancelActionHandler = cancelActionHandler {
                    cancelActionHandler()
                }
            }
            alertController.addAction(cancelAction)
        }

        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController {
    enum AlertType {
        case single
        case double
    }
}
