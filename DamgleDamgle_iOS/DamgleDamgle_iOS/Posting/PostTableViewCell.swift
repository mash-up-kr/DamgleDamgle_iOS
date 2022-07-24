//
//  PostTableViewCell.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/03.
//

import UIKit

protocol TableViewCellDelegate: AnyObject {
    func iconButtonAnimationIsClosed()
}
final class PostTableViewCell: UITableViewCell, Reusable {
    internal var addSelectedIcon: ((IconsButton) -> Void)?
    internal var deleteSeletedIcon: (() -> Void)?
    weak var delegate: TableViewCellDelegate?
    private var nowSelectedButtonIcon: IconsButton = IconsButton.none {
        didSet {
            closeIconsButton(isSelected: nowSelectedButtonIcon)
        }
    }

    private var id: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        setViewDefault()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconsBackgroundView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        placeAddressLabel.text = ""
        userNameLabel.text = ""
        checkMeLabel.text = ""
        timeLabel.text = ""
        contentLabel.text = ""
        iconsStartButton.isSelected = false
        iconsButtonCollection.forEach { $0.isSelected = false }
    }

    private func setViewDefault() {
        iconsStartButton.imageView?.contentMode = .scaleAspectFit

        guard let cellModel = cellModel else { return }
        setupIconsView(selectedIcons: cellModel.selectedIcons)
    }

    func setupUI(viewModel: PostModel) {
        placeAddressLabel.text = viewModel.placeAddress
        userNameLabel.text = viewModel.userName
        checkMeLabel.text = viewModel.isChecked ? " • ME" : ""
        timeLabel.text = viewModel.timeText
        contentLabel.text = viewModel.content
        setupIconsView(selectedIcons: viewModel.selectedIcons)
        setupIconsStartButton(selectedIcon: viewModel.icon ?? IconsButton.none)
        setupIconsButton(selectedIcon: viewModel.icon ?? IconsButton.none)
        cellModel = viewModel
    }

    private func setupIconsStartButton(selectedIcon: IconsButton) {
        iconsStartButton.setImage(selectedIcon.selectedButtonIconsImage, for: .normal)
    }

    private func setupIconsButton(selectedIcon: IconsButton) {
        for button in iconsButtonCollection {
            button.isSelected = button.tag == selectedIcon.rawValue ? true : false
        }
    }

    func setupIconsView(selectedIcons: [SelectedIconButton]) {
        if selectedIcons.isEmpty {
            let iconsView = NoIconsView()
            iconsBackgroundView.addSubview(iconsView)
            iconsView.frame = iconsBackgroundView.bounds
        } else if selectedIcons.count == 1 {
            let iconsView = OneIconView()
            iconsBackgroundView.addSubview(iconsView)
            iconsView.frame = iconsBackgroundView.bounds
            iconsView.setupText(selectedIcons: selectedIcons)
        } else {
            let iconsView = ManyIconsView(frame: iconsBackgroundView.bounds)
            iconsBackgroundView.addSubview(iconsView)
            iconsView.frame = iconsBackgroundView.bounds
            iconsView.setupUI(selectedIcons: selectedIcons)
        }
    }

    // MARK: - InterfaceBuilder Links

    @IBOutlet private weak var placeAddressLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var checkMeLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var iconsStartButton: UIButton!
    @IBOutlet private weak var reportButton: UIButton!
    @IBOutlet weak var iconsBackgroundView: UIView!
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

            let isSelectedIcon: IconsButton = isSelectedIcons(button: sender)
            self.deleteSeletedIcon?(isSelectedIcon)
            self.nowSelectedButtonIcon = IconsButton.none
        } else {
            sender.isSelected = true
            deselectAnotherButton(button: sender)

            let isSelectedIcon: IconsButton = isSelectedIcons(button: sender)
            addSelectedIcon?(isSelectedIcon)
            nowSelectedButtonIcon = isSelectedIcon
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
        guard let button = IconsButton(rawValue: button.tag) else {
            return .none
        }
        return button
    }

    private func openIconsButton() {
        let contentViewWidth = self.contentView.frame.width
        iconsButtonXPointConstraint.forEach {
            let constraint: NSLayoutConstraint = $0
            let constant: CGFloat? = {
                if constraint.identifier == "likeButton" {
                    return IconsButton.likeButton.distRatioFromStartButton * contentViewWidth
                } else if constraint.identifier == "angryButton" {
                    return IconsButton.angryButton.distRatioFromStartButton * contentViewWidth
                } else if constraint.identifier == "amazingButton" {
                    return IconsButton.amazingButton.distRatioFromStartButton * contentViewWidth
                } else if constraint.identifier == "sadButton" {
                    return IconsButton.sadButton.distRatioFromStartButton * contentViewWidth
                } else if constraint.identifier == "bestButton" {
                    return IconsButton.bestButton.distRatioFromStartButton * contentViewWidth
                } else {
                    return nil
                }
            }()

            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self = self, let constant = constant else { return }
                constraint.constant = constant
                self.layoutIfNeeded()
            }
        }
    }

    private func closeIconsButton(isSelected icon: IconsButton) {
        iconsButtonXPointConstraint.forEach {
            let constraint: NSLayoutConstraint = $0
            let constant: CGFloat = IconsButton.none.distRatioFromStartButton

            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self = self else { return }

                constraint.constant = constant
                self.layoutIfNeeded()
            } completion: { [weak self] _ in
                guard let self = self else { return }

                self.delegate?.iconButtonAnimationIsClosed()
                self.iconsStartButton.isSelected = false

                guard let selectedIconImage = icon.selectedButtonIconsImage else { return }
                self.iconsStartButton.setImage(selectedIconImage, for: .normal)
            }
        }
    }
}

enum IconsButton: Int {
    case likeButton = 0
    case angryButton
    case amazingButton
    case sadButton
    case bestButton
    case none

    var distRatioFromStartButton: CGFloat {
        switch self {
        case .likeButton:
            return -(73/375)
        case .angryButton:
            return -(121/375)
        case .amazingButton:
            return -(169/375)
        case .sadButton:
            return -(217/375)
        case .bestButton:
            return -(265/375)
        case .none:
            return 0
        }
    }

    var selectedButtonIconsImage: UIImage? {
        switch self {
        case .likeButton:
            return UIImage(named: "icn=like_y")
        case .angryButton:
            return UIImage(named: "icn=angry_y")
        case .amazingButton:
            return UIImage(named: "icn=amazing_y")
        case .sadButton:
            return UIImage(named: "icn=sad_y")
        case .bestButton:
            return UIImage(named: "icn=best_y")
        case .none:
            return UIImage(named: "icn=best")
        }
    }

    var selectedImageViewIconImage: UIImage? {
        switch self {
        case .likeButton:
            return UIImage(named: "img=like")
        case .angryButton:
            return UIImage(named: "img=angry")
        case .amazingButton:
            return UIImage(named: "img=amazing")
        case .sadButton:
            return UIImage(named: "img=sad")
        case .bestButton:
            return UIImage(named: "img=best")
        case .none:
            return nil
        }
    }

    var tag: Int {
        self.rawValue
    }
}
