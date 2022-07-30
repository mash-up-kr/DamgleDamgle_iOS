//
//  RoundLabel.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/16.
//

import UIKit

final class RoundLabel: UILabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateViewPropertie()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        updateViewPropertie()
    }

    private func updateViewPropertie() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = self.frame.width / 2
        layer.masksToBounds = true
    }
}
