//
//  ToastView.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/08/31.
//

import UIKit

final class ToastView: UIView {

    var bottomConstraint: NSLayoutConstraint?

    override func layoutSubviews() {
        layer.masksToBounds = false
        layer.cornerRadius = bounds.height / 2.0
    }
}
