//
//  ManyIconsView.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/16.
//

import UIKit
import SwiftUI

final class ManyIconsView: UIView {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    private func initialize() {
        let nib = Bundle.main.loadNibNamed("ManyIconsView", owner: self, options: nil)

        guard let manyIconsView = nib?.first as? UIView else { return }

        manyIconsView.frame = self.bounds
        addSubview(manyIconsView)
    }

    func setupUI(selectedIcons: [SelectedIconButton]) {
        let iconsRawValue = selectedIcons.map { $0.icon.rawValue }
        let iconsCount = selectedIcons.map { $0.count }

        iconsLabelCollection.forEach {
            if iconsRawValue.contains($0.tag) {
                $0.isHidden = false

                guard let index = iconsRawValue.firstIndex(of: $0.tag) else { return }
                $0.text = "\(iconsCount[index])"
            } else {
                $0.isHidden = true
            }
        }

        iconsImageViewCollection.forEach {
            if iconsRawValue.contains($0.tag) {
                $0.isHidden = false
            } else {
                $0.isHidden = true
            }
        }
    }

    // MARK: - InterfaceBuilder Links

    @IBOutlet private var iconsLabelCollection: [RoundLabel]!
    @IBOutlet private var iconsImageViewCollection: [RotatableImageView]!
}
