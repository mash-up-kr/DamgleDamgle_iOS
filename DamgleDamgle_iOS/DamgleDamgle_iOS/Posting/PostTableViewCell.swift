//
//  PostTableViewCell.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/03.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    static let identifier = "PostTableViewCell"

    internal var addSelectedIcon: ((IconsButton) -> Void)?
    internal var deleteSeletedIcon: (() -> Void)?
    private var nowSelectedButtonIcon: IconsButton = IconsButton.none {
        didSet {
            self.changeConstraintsAndImage(to: self.nowSelectedButtonIcon)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setViewDefault()
    }

    private func setViewDefault() {
        self.iconsStartButton.imageView?.contentMode = .scaleAspectFit
    }

    internal func setUI(viewModel: PostModel) {
        self.placeAddressLabel.text = viewModel.placeAddress
        self.userNameLabel.text = viewModel.userName
        self.checkMeLabel.text = viewModel.checkMyContent ? " • ME" : ""
        self.timeLabel.text = viewModel.time
        self.contentLabel.text = viewModel.content
    }

    // MARK: - InterfaceBuilder Links

    @IBOutlet private weak var placeAddressLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var checkMeLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var iconsStartButton: UIButton!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var angryButton: UIButton!
    @IBOutlet private weak var amazingButton: UIButton!
    @IBOutlet private weak var sadButton: UIButton!
    @IBOutlet private weak var bestButton: UIButton!

    @IBOutlet private weak var likeButtonXPointConstraint: NSLayoutConstraint!
    @IBOutlet private weak var angryButtonXPointConstraint: NSLayoutConstraint!
    @IBOutlet private weak var amazingButtonXPointConstraint: NSLayoutConstraint!
    @IBOutlet private weak var sadButtonXPointConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bestButtonXPointConstraint: NSLayoutConstraint!

    @IBAction private func iconStartButtonTouchUp(_ sender: UIButton) {
        let stackConstraints: [(NSLayoutConstraint, IconsButton)] = [(self.likeButtonXPointConstraint, IconsButton.likeButton), (self.angryButtonXPointConstraint, IconsButton.angryButton), (self.amazingButtonXPointConstraint, IconsButton.amazingButton), (self.sadButtonXPointConstraint, IconsButton.sadButton), (self.bestButtonXPointConstraint, IconsButton.bestButton)]

        if sender.isSelected {
            sender.isSelected = false

            stackConstraints.forEach {
                let constraint = $0.0
                let constant = IconsButton.none.distanceFromStartButton

                UIView.animate(withDuration: 0.5) { [weak self] in
                    guard let self = self else { return }

                    constraint.constant = constant ?? 0
                    self.layoutIfNeeded()
                }
            }
        } else {
            sender.isSelected = true

            stackConstraints.forEach {
                let constraint = $0.0
                let constant = $0.1.distanceFromStartButton

                UIView.animate(withDuration: 0.5) { [weak self] in
                    guard let self = self else { return }

                    constraint.constant = constant ?? 0
                    self.layoutIfNeeded()
                }
            }
        }
    }

    @IBAction private func likeButtonTouchUp(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            self.deleteSeletedIcon?()
            self.nowSelectedButtonIcon = IconsButton.none

        } else {
            sender.isSelected = true
            self.deselectAnotherButton(button: sender)
            self.addSelectedIcon?(IconsButton.likeButton)
            self.nowSelectedButtonIcon = IconsButton.likeButton
        }
    }

    @IBAction private func angryButtonTouchUp(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            self.deleteSeletedIcon?()
            self.nowSelectedButtonIcon = IconsButton.none
        } else {
            sender.isSelected = true
            self.deselectAnotherButton(button: sender)
            self.addSelectedIcon?(IconsButton.angryButton)
            self.nowSelectedButtonIcon = IconsButton.angryButton
        }
    }

    @IBAction private func amazingButtonTouchUp(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            self.deleteSeletedIcon?()
            self.nowSelectedButtonIcon = IconsButton.none
        } else {
            sender.isSelected = true
            self.deselectAnotherButton(button: sender)
            self.addSelectedIcon?(IconsButton.amazingButton)
            self.nowSelectedButtonIcon = IconsButton.amazingButton
        }
    }

    @IBAction private func sadButtonTouchUp(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            self.deleteSeletedIcon?()
            self.nowSelectedButtonIcon = IconsButton.none
        } else {
            sender.isSelected = true
            self.deselectAnotherButton(button: sender)
            self.addSelectedIcon?(IconsButton.sadButton)
            self.nowSelectedButtonIcon = IconsButton.sadButton
        }
    }

    @IBAction private func bestButtonTouchUp(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            self.deleteSeletedIcon?()
            self.nowSelectedButtonIcon = IconsButton.none
        } else {
            sender.isSelected = true
            self.deselectAnotherButton(button: sender)
            self.addSelectedIcon?(IconsButton.bestButton)
            self.nowSelectedButtonIcon = IconsButton.bestButton
        }
    }

    private func deselectAnotherButton(button: UIButton) {
        if button.isSelected {
            let iconsButtons = [self.likeButton, self.angryButton, self.amazingButton, self.sadButton, self.bestButton]

            iconsButtons.forEach {
                if $0 != button {
                    $0?.isSelected = false
                }
            }
        }
    }

    private func changeConstraintsAndImage(to icon: IconsButton) {
        let stackConstraints: [(NSLayoutConstraint, IconsButton)] = [(self.likeButtonXPointConstraint, IconsButton.likeButton), (self.angryButtonXPointConstraint, IconsButton.angryButton), (self.amazingButtonXPointConstraint, IconsButton.amazingButton), (self.sadButtonXPointConstraint, IconsButton.sadButton), (self.bestButtonXPointConstraint, IconsButton.bestButton)]

        stackConstraints.forEach {
            let constraint = $0.0
            let constant = IconsButton.none.distanceFromStartButton

            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self = self else { return }

                constraint.constant = constant ?? 0
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

    var distanceFromStartButton: CGFloat? {
        switch self {
        case .likeButton: return -73
        case .angryButton: return -121
        case .amazingButton: return -169
        case .sadButton: return -217
        case .bestButton: return -265
        case .none: return 0
        }
    }

    var selectImageName: String? {
        switch self {
        case .likeButton: return "icn=like_y"
        case .angryButton: return "icn=angry_y"
        case .amazingButton: return "icn=amazing_y"
        case .sadButton: return "icn=sad_y"
        case .bestButton: return "icn=best_y"
        case .none: return nil
        }
    }
}
