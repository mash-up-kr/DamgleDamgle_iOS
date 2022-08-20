//
//  ToastView.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/08/06.
//

import UIKit

final class ToastLabel: UILabel, NibBased {
    
    private var padding = UIEdgeInsets(top: 12.0, left: 24.0, bottom: 12.0, right: 24.0)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
    
    func setupViewProperties() {
        font = UIFont.boldSystemFont(ofSize: 13.0)
        let newSize = self.intrinsicContentSize
        frame.size = newSize
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = self.frame.height / 2
        layer.masksToBounds = true
        textColor = .white
        backgroundColor = .black
        textAlignment = .center
    }
    
    func setupUI(text: String?) {
        self.text = text
        setupViewProperties()
    }
}
