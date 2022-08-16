//
//  CustomLineSpacingLabel.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/08/06.
//

import UIKit

final class LineSpacingLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateViewPropertie()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        updateViewPropertie()
    }

    private func updateViewPropertie() {
        let attrString = NSMutableAttributedString(string: text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        attributedText = attrString
    }
}
