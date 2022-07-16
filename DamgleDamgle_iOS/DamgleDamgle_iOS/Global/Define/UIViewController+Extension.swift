//
//  UIView+Extension.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/07.
//

import UIKit

extension UIViewController {
    func showSingleAlertController(title: String, message: String, okActionTitle: String = "확인", okActionHandler: @escaping () -> Void) {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingAction: UIAlertAction = UIAlertAction(title: okActionTitle, style: .default) { _ in
            okActionHandler()
        }
        alertController.addAction(settingAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
