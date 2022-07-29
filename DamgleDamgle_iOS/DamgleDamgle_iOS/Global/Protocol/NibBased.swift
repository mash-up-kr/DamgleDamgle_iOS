//
//  File.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/30.
//

import UIKit

protocol NibBased: AnyObject {
    static var identifier: String { get }
    func initialize()
}

extension NibBased where Self: UIView {
    static var identifier: String {
        String(describing: self)
    }

    func initialize() {
        let nib = Bundle.main.loadNibNamed(Self.identifier, owner: self, options: nil)

        guard let contentView = nib?.first as? UIView else { return }

        contentView.frame = self.bounds
        addSubview(contentView)
    }
}
