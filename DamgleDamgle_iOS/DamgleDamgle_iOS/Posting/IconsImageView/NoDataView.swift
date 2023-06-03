//
//  NoDataView.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/28.
//

import UIKit

final class NoDataView: UIView, NibBased {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
}
