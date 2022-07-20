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
                return UIColor(named: "grey1000")!
            case .disabled:
                return UIColor(named: "grey600")!
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .normal:
                return UIColor(named: "white")!
            case .disabled:
                return UIColor(named: "grey400")!
            }
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

    override var isEnabled: Bool {
        didSet {
            updateButtonColor(isEnabled: isEnabled)
        }
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
    }
    
    private func updateButtonColor(isEnabled: Bool) {
        var currentState: ButtonState
        
        if isEnabled {
            currentState = ButtonState.normal
            self.backgroundColor = currentState.backgroundColor
            self.setTitleColor(currentState.textColor, for: .normal)
        } else {
            currentState = ButtonState.disabled
            self.backgroundColor = currentState.backgroundColor
            self.setTitleColor(currentState.textColor, for: .disabled)
        }
    }
}
