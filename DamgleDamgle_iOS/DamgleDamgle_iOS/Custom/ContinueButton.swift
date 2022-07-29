//
//  ContinueButton.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/20.
//

import UIKit

final class ContinueButton: UIButton {
    private enum ButtonState {
        case normal
        case disabled
        
        var backgroundColor: UIColor {
            switch self {
            case .normal:
                return UIColor(named: "grey1000") ?? .systemGray
            case .disabled:
                return UIColor(named: "grey600") ?? .systemGray
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .normal:
                return UIColor(named: "white") ?? .systemGray
            case .disabled:
                return UIColor(named: "grey400") ?? .systemGray
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            updateButtonColor(isEnabled: isEnabled)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    private func setUp() {
        guard let title = titleLabel?.text else {
            return
        }
        
        if let font = UIFont(name: "Pretendard-Medium", size: 18.0) {
            let attributedString = NSAttributedString(
                string: title,
                attributes: [
                    .font: font
                ]
            )
            setAttributedTitle(attributedString, for: .normal)
            setAttributedTitle(attributedString, for: .disabled)
        }
        
        titleLabel?.adjustsFontSizeToFitWidth = true
        
        setTitleColor(ButtonState.normal.textColor, for: .normal)
        setTitleColor(ButtonState.disabled.textColor, for: .disabled)
    }
    
    private func updateButtonColor(isEnabled: Bool) {
        if isEnabled {
            self.backgroundColor = ButtonState.normal.backgroundColor
        } else {
            self.backgroundColor = ButtonState.disabled.backgroundColor
        }
    }
}
