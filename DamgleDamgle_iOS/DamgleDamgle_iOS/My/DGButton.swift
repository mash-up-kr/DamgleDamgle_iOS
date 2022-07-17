//
//  DGButton.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/16.
//

import UIKit

final class DGButton: UIButton {
    private let selectedBackgroundColor = UIColor(named: "grey1000")
    private let selectedTextColor = UIColor.white
    private let normalBackgroundColor = UIColor.clear
    private let normalTextColor = UIColor(named: "grey1000")
    
    override var isSelected: Bool {
        didSet {
            showSelectedAnimation(isSelected)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        setupTitle()
        
        layer.masksToBounds = true
        layer.cornerRadius = 5.0
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
    
    private func showSelectedAnimation(_ isSelected: Bool) {
        UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) { [weak self] in
            self?.backgroundColor = isSelected == true ? self?.selectedBackgroundColor : self?.normalBackgroundColor
        }.startAnimation()
    }
}
