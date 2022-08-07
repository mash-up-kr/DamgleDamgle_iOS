//
//  ToastView.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/08/08.
//

import UIKit

class ToastView: UIView, NibBased {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    internal func setupViewProperties() {
        let newSize = titleLabel.intrinsicContentSize
        titleLabel.frame.size = newSize
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = self.frame.height / 2
        layer.masksToBounds = true
        titleLabel.backgroundColor = .yellow
    }
    
    func setupUI(text: String?) {
        self.titleLabel.text = text
        setupViewProperties()
    }
}
