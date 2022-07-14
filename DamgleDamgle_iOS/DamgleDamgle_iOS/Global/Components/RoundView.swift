//
//  RoundView.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/06.
//

import UIKit

@IBDesignable
final class RoundView: UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
}
