//
//  XibNoIconsView.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/16.
//

import UIKit

final class NoIconsView: UIView {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    private func initialize() {
        let nib = Bundle.main.loadNibNamed("NoIconsView", owner: self, options: nil)

        guard let noIconsView = nib?.first as? UIView else { return }

        noIconsView.frame = self.bounds
        addSubview(noIconsView)
    }
}
