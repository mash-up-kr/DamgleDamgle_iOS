//
//  PostTableViewCell.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/03.
//

import UIKit

protocol TableViewCellDelegate: AnyObject {
    func iconButtonAnimationIsClosed(icon: IconsButton)
}

final class PostTableViewCell: UITableViewCell, Reusable {
    weak var delegate: TableViewCellDelegate?
    var addSelectedIcon: ((IconsButton) -> Void)?
    var deleteSeletedIcon: ((IconsButton) -> Void)?
    private var nowSelectedButtonIcon: IconsButton = IconsButton.none {
        didSet {
            closeIconsButton(isSelected: nowSelectedButtonIcon)
        }
    }

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
    }

    func setupUI(viewModel: PostModel) {
        placeAddressLabel.text = viewModel.placeAddress
        userNameLabel.text = viewModel.userName
        checkMeLabel.text = viewModel.isChecked ? " • ME" : ""
        timeLabel.text = viewModel.timeText
        contentLabel.text = viewModel.content
        setupIconsView(selectedButtonIcons: viewModel.selectedIcons)
        setupIconsStartButton(selectedIcon: viewModel.icon ?? IconsButton.none)
        setupIconsButton(selectedIcon: viewModel.icon ?? IconsButton.none)
    }

    private func setupIconsStartButton(selectedIcon: IconsButton) {
        iconsStartButton.setImage(selectedIcon.selectedButtonIconsImage, for: .normal)
    }

    private func setupIconsButton(selectedIcon: IconsButton) {
        for button in iconsButtonCollection {
            button.isSelected = button.tag == selectedIcon.rawValue ? true : false
        }
    }

    func setupIconsView(selectedButtonIcons: [SelectedIconButton]) {
        if selectedButtonIcons.isEmpty {
            let iconsView = NoIconsView(frame: .zero)
            iconsBackgroundView.addSubview(iconsView)
            iconsView.frame = iconsBackgroundView.bounds
        } else if selectedButtonIcons.count == 1 {
            let iconsView = OneIconView(frame: .zero)
            iconsBackgroundView.addSubview(iconsView)
            iconsView.frame = iconsBackgroundView.bounds
            iconsView.setupText(selectedIcons: selectedButtonIcons)
        } else {
            let iconsView = ManyIconsView(frame: .zero)
            iconsBackgroundView.addSubview(iconsView)
            iconsView.frame = iconsBackgroundView.bounds
            iconsView.setupUI(selectedIcons: selectedButtonIcons)
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
            closeIconsButton(isSelected: nowSelectedButtonIcon)
        } else {
            sender.isSelected = true
            openIconsButton()
        }
    }

    @IBAction private func touchUpIconsButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false

            let isSelectedIcon: IconsButton = isSelectedIcons(button: sender)
            deleteSeletedIcon?(isSelectedIcon)
            nowSelectedButtonIcon = IconsButton.none
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
        guard let selectedIconImage = nowSelectedButtonIcon.inActiveButtonIconimage else { return }
        iconsStartButton.setImage(selectedIconImage, for: .selected)
        
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
                        
            UIView.animate(withDuration: 1.0) { [weak self] in
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

            UIView.animate(withDuration: 1.0) { [weak self] in
                guard let self = self else { return }

                constraint.constant = constant
                self.layoutIfNeeded()
            } completion: { [weak self] _ in
                guard let self = self else { return }

                self.delegate?.iconButtonAnimationIsClosed(icon: self.nowSelectedButtonIcon)
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
    
    var inActiveButtonIconimage: UIImage? {
        switch self {
        case .likeButton:
            return UIImage(named: "icn=like_inactive")
        case .angryButton:
            return UIImage(named: "icn=angry_inactive")
        case .amazingButton:
            return UIImage(named: "icn=amazing_inactive")
        case .sadButton:
            return UIImage(named: "icn=sad_inactive")
        case .bestButton:
            return UIImage(named: "icn=best_inactive")
        case .none:
            return UIImage(named: "icn=best_inactive")
        }
    }
    
    var toastMessageTitle: String? {
        switch self {
        case .likeButton:
            return "좋아요 이모지로 수정되었습니다!"
        case .angryButton:
            return "화나요 이모지로 수정되었습니다!"
        case .amazingButton:
            return "놀라워요 이모지로 수정되었습니다!"
        case .sadButton:
            return "슬퍼요 이모지로 수정되었습니다!"
        case .bestButton:
            return "최고에요 이모지로 수정되었습니다!"
        case .none:
            return nil
        }
    }

    var tag: Int {
        self.rawValue
    }
}
