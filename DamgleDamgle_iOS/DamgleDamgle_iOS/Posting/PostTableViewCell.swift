//
//  PostTableViewCell.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/03.
//

import UIKit

final class PostTableViewCell: UITableViewCell {

    static let identifier: String = "PostTableViewCell"

    internal var addSelectedIcon: ((IconsButton) -> Void)?
    internal var deleteSeletedIcon: (() -> Void)?
    private var nowSelectedButtonIcon: IconsButton = IconsButton.none {
        didSet {
            self.closeIconsButton(isSelected: self.nowSelectedButtonIcon)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setViewDefault()
    }

    private func setViewDefault() {
        self.iconsStartButton.imageView?.contentMode = .scaleAspectFit
    }

    internal func setupText(viewModel: PostModel) {
        self.placeAddressLabel.text = viewModel.placeAddress
        self.userNameLabel.text = viewModel.userName
        self.checkMeLabel.text = viewModel.isChecked ? " • ME" : ""
        self.timeLabel.text = viewModel.timeText
        self.contentLabel.text = viewModel.content
    }

    // MARK: - InterfaceBuilder Links

    @IBOutlet private weak var placeAddressLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var checkMeLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var iconsStartButton: UIButton!

    @IBOutlet private var iconsButtonCollection: [SelectableButton]!
    @IBOutlet private var iconsButtonXPointConstraint: [NSLayoutConstraint]!

    @IBAction private func touchUpiconStartButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            closeIconsButton(isSelected: self.nowSelectedButtonIcon)
        } else {
            sender.isSelected = true
            openIconsButton()
        }
    }

    @IBAction private func touchUpIconsButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            self.deleteSeletedIcon?()
            self.nowSelectedButtonIcon = IconsButton.none
        } else {
            sender.isSelected = true
            self.deselectAnotherButton(button: sender)

            let isSelectedIcon: IconsButton = isSelectedIcons(button: sender)
            self.addSelectedIcon?(isSelectedIcon)
            self.nowSelectedButtonIcon = isSelectedIcon
        }
    }

    private func deselectAnotherButton(button: UIButton) {
        if button.isSelected {
            iconsButtonCollection.forEach {
                if $0 != button {
                    $0.isSelected = false
                }
            }
        }
    }

    private func isSelectedIcons(button: UIButton) -> IconsButton {
        switch button.tag {
        case 0:
            return IconsButton.likeButton
        case 1:
            return IconsButton.angryButton
        case 2:
            return IconsButton.amazingButton
        case 3:
            return IconsButton.sadButton
        case 4:
            return IconsButton.bestButton
        default:
            return IconsButton.none
        }
    }

    private func openIconsButton() {
        iconsButtonXPointConstraint.forEach {
            let constraint: NSLayoutConstraint = $0
            let constant: CGFloat? = {
                if constraint.identifier == "likeButton" {
                    return IconsButton.likeButton.distanceFromStartButton
                } else if constraint.identifier == "angryButton" {
                    return IconsButton.angryButton.distanceFromStartButton
                } else if constraint.identifier == "amazingButton" {
                    return IconsButton.amazingButton.distanceFromStartButton
                } else if constraint.identifier == "sadButton" {
                    return IconsButton.sadButton.distanceFromStartButton
                } else if constraint.identifier == "bestButton" {
                    return IconsButton.bestButton.distanceFromStartButton
                } else {
                    return nil
                }
            }()

            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self = self else { return }
                guard let constant = constant else { return }

                constraint.constant = constant
                self.layoutIfNeeded()
            }
        }
    }

    private func closeIconsButton(isSelected icon: IconsButton) {
        iconsButtonXPointConstraint.forEach {
            let constraint: NSLayoutConstraint = $0
            let constant: CGFloat = IconsButton.none.distanceFromStartButton

            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self = self else { return }

                constraint.constant = constant
                self.layoutIfNeeded()
            } completion: { [weak self] _ in
                guard let self = self else { return }

                self.iconsStartButton.isSelected = false

                guard let imageName = icon.selectImageName else { return }
                self.iconsStartButton.setImage(UIImage(named: imageName), for: .normal)
            }
        }
    }
}

enum IconsButton {
    case likeButton
    case angryButton
    case amazingButton
    case sadButton
    case bestButton
    case none

    var distanceFromStartButton: CGFloat {
        switch self {
        case .likeButton:
            return -73
        case .angryButton:
            return -121
        case .amazingButton:
            return -169
        case .sadButton:
            return -217
        case .bestButton:
            return -265
        case .none:
            return 0
        }
    }

    var selectImageName: String? {
        switch self {
        case .likeButton:
            return "icn=like_y"
        case .angryButton:
            return "icn=angry_y"
        case .amazingButton:
            return "icn=amazing_y"
        case .sadButton:
            return "icn=sad_y"
        case .bestButton:
            return "icn=best_y"
        case .none:
            return nil
        }
    }
}
