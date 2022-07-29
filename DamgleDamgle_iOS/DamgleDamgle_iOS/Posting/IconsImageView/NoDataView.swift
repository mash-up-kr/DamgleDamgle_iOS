//
//  NoDataView.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/28.
//

import UIKit

class NoDataView: UIView {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    private func initialize() {
        let nib = Bundle.main.loadNibNamed("NoDataView", owner: self, options: nil)

        guard let noDataView = nib?.first as? UIView else { return }

        noDataView.frame = self.bounds
        addSubview(noDataView)
    }
}
