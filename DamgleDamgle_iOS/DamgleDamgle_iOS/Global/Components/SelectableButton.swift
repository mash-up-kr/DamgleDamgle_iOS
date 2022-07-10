//
//  SelectedButton.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/03.
//

import Foundation
import UIKit

class SelectableButton: UIButton {

    @IBInspectable var normalImage: UIImage? {
        didSet {
            update()
        }
    }

    @IBInspectable var selectImage: UIImage? {
        didSet {
            update()
        }
    }

    @IBInspectable var normalBackgroundColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
        didSet {
            update()
        }
    }

    @IBInspectable var selectBackgroundColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) {
        didSet {
            update()
        }
    }

    @IBInspectable var normalTitleColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) {
        didSet {
            update()
        }
    }

    @IBInspectable var selectTitleColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
        didSet {
            update()
        }
    }

    @IBInspectable var normalBorderColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) {
        didSet {
            update()
        }
    }

    @IBInspectable var selectBorderColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) {
        didSet {
            update()
        }
    }

    @IBInspectable var normalTintColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) {
        didSet {
            update()
        }
    }

    @IBInspectable var selectTintColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) {
        didSet {
            update()
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 8.0 {
        didSet {
            update()
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            update()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        update()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        update()
    }

    override func prepareForInterfaceBuilder() {
        update()
    }

    override var isSelected: Bool {
        didSet {
            update()
        }
    }

    private func update() {
        layer.cornerRadius = cornerRadius
        setTitleColor(normalTitleColor, for: .normal)
        setTitleColor(selectTitleColor, for: .selected)
        backgroundColor = isSelected ? selectBackgroundColor : normalBackgroundColor
        layer.borderColor = isSelected ? selectBorderColor.cgColor : normalBorderColor.cgColor
        tintColor = isSelected ? selectTintColor : normalTintColor
        layer.borderWidth = borderWidth
        setImage(normalImage, for: .normal)
        setImage(selectImage, for: .selected)
//        imageView?.contentMode = .scaleAspectFit
    }
}
