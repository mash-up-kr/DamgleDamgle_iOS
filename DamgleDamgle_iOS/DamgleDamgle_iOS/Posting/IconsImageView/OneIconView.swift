//
//  oneIconView.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/16.
//

import UIKit

final class OneIconView: UIView, NibBased {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    func setupText(selectedIcons: [SelectedIconButton]) {
        guard let selectedIcon = selectedIcons.first else { return }
        iconCountLabel.text = "\(selectedIcon.count)"

        guard let iconImage = selectedIcon.icon.selectedImageViewIconImage else { return }
        iconImageView.image = iconImage
    }

    // MARK: - InterfaceBuilder Links
    @IBOutlet private weak var iconImageView: RotatableImageView!
    @IBOutlet private weak var iconCountLabel: RoundLabel!
}
