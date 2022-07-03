//
//  SelectedButton.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/03.
//

import Foundation
import UIKit

class SelectableButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleColor(UIColor.init(named: "grey900"), for: .selected)
        setTitleColor(UIColor.init(named: "grey700"), for: .normal)
        tintColor = .clear
    }
}
