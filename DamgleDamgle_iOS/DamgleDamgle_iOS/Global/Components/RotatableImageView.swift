//
//  RotatableImageView.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/16.
//

import UIKit

final class RotatableImageView: UIImageView {

    @IBInspectable var rotationDegrees: Float = 0 {
        didSet {
            updateViewPropertie()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateViewPropertie()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        updateViewPropertie()
    }

    override func prepareForInterfaceBuilder() {
        updateViewPropertie()
    }

    private func updateViewPropertie() {
        let angle = NSNumber(value: rotationDegrees / 180.0 * Float.pi)
        layer.setValue(angle, forKeyPath: "transform.rotation.z")
    }
}
