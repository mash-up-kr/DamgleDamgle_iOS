//
//  DGButton.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/16.
//

import UIKit

final class DGButton: UIButton {
    private let selectedTextColor = UIColor.white
    private let normalTextColor = UIColor(named: "grey1000")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTitle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTitle()
    }

    private func setupTitle() {
        guard let title = titleLabel?.text else {
            return
        }
        
        if let normalFont = UIFont(name: "Pretendard-Medium", size: 16.0) {
            let normalAttributedString = NSAttributedString(
                string: title,
                attributes: [
                    .font: normalFont,
                    .foregroundColor: normalTextColor ?? .black
                ]
            )
            setAttributedTitle(normalAttributedString, for: .normal)
        }
        
        if let selectedFont = UIFont(name: "Pretendard-SemiBold", size: 16.0) {
            let selectedAttributedString = NSAttributedString(
                string: title,
                attributes: [
                    .font: selectedFont,
                    .foregroundColor: selectedTextColor
                ]
            )
            setAttributedTitle(selectedAttributedString, for: .selected)
        }

        titleLabel?.adjustsFontSizeToFitWidth = true
    }
}
