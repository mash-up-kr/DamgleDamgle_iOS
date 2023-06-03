//
//  SelectedButton.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/03.
//

import Foundation
import UIKit

final class SelectableButton: UIButton {

    @IBInspectable var normalImage: UIImage? {
        didSet {
            updateViewPropertie()
        }
    }

    @IBInspectable var selectImage: UIImage? {
        didSet {
            updateViewPropertie()
        }
    }

    @IBInspectable var normalBackgroundColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
        didSet {
            updateViewPropertie()
        }
    }

    @IBInspectable var selectBackgroundColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) {
        didSet {
            updateViewPropertie()
        }
    }

    @IBInspectable var normalTitleColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) {
        didSet {
            updateViewPropertie()
        }
    }

    @IBInspectable var selectTitleColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
        didSet {
            updateViewPropertie()
        }
    }

    @IBInspectable var normalBorderColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) {
        didSet {
            updateViewPropertie()
        }
    }

    @IBInspectable var selectBorderColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) {
        didSet {
            updateViewPropertie()
        }
    }

    @IBInspectable var normalTintColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) {
        didSet {
            updateViewPropertie()
        }
    }

    @IBInspectable var selectTintColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) {
        didSet {
            updateViewPropertie()
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 8.0 {
        didSet {
            updateViewPropertie()
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
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

    override var isSelected: Bool {
        didSet {
            updateViewPropertie()
        }
    }

    private func updateViewPropertie() {
        layer.cornerRadius = cornerRadius
        setTitleColor(normalTitleColor, for: .normal)
        setTitleColor(selectTitleColor, for: .selected)
        backgroundColor = isSelected ? selectBackgroundColor : normalBackgroundColor
        layer.borderColor = isSelected ? selectBorderColor.cgColor : normalBorderColor.cgColor
        tintColor = isSelected ? selectTintColor : normalTintColor
        layer.borderWidth = borderWidth
        setImage(normalImage, for: .normal)
        setImage(selectImage, for: .selected)
    }
}
