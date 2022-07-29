//
//  APIErrorView.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/28.
//

import UIKit

final class APIErrorView: UIView {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    private func initialize() {
        let nib = Bundle.main.loadNibNamed("APIErrorView", owner: self, options: nil)

        guard let apiErrorView = nib?.first as? UIView else { return }

        apiErrorView.frame = self.bounds
        addSubview(apiErrorView)
    }
}
