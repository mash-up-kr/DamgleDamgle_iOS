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
    weak var delegate: TableViewCellDelegate?
//    var addSelectedIcon: ((IconsButton) -> Void)?
//    var deleteSeletedIcon: ((IconsButton) -> Void)?
    var addSelectedIcon: ((ReactionType) -> Void)?
    var deleteSeletedIcon: (() -> Void)?
//    private var nowSelectedButtonIcon: IconsButton = IconsButton.none {
//        didSet {
//            closeIconsButton(isSelected: nowSelectedButtonIcon)
//        }
//    }
    private var nowSelectedReaction: ReactionType = ReactionType.none {
        didSet {
            closeIconsButton(isSelected: nowSelectedReaction)
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
        iconsButtonXPointConstraint.forEach { $0.constant = 0 }
    }
    
    private func setViewDefault() {
        iconsStartButton.imageView?.contentMode = .scaleAspectFit
    }
    
    //    func setupUI(viewModel: PostModel) {
    //        placeAddressLabel.text = viewModel.placeAddress
    //        userNameLabel.text = viewModel.userName
    //        checkMeLabel.text = viewModel.isChecked ? " • ME" : ""
    //        timeLabel.text = viewModel.timeText
    //        contentLabel.text = viewModel.content
    //        setupIconsView(selectedButtonIcons: viewModel.selectedIcons)
    //        setupIconsStartButton(selectedIcon: viewModel.icon ?? IconsButton.none)
    //        setupIconsButton(selectedIcon: viewModel.icon ?? IconsButton.none)
    //    }
    
    func setupTestUI(viewModel: Story?) {
        guard let viewModel = viewModel else { return }
        // TODO: placeAddress값 서버에서 떨궈줘야함
        //        placeAddressLabel.text = viewModel.
        placeAddressLabel.text = "충무로"
        userNameLabel.text = viewModel.nickname
        checkMeLabel.text = viewModel.userNo == UserManager.shared.userNo ? " • ME" : ""
        timeLabel.text = viewModel.offsetTimeText
        contentLabel.text = viewModel.content
        // TODO: Reaction 떨궈주는 값을 그려주기
        setupTestIconsView(reactions: viewModel.reactions)
        // TODO: 내가 선택한 Reaction 값에 따라 view 그려주기 -> 임시적으로 목데이터 사용
        //        setupIconsStartButton(reaction: viewModel.reaction ?? IconsButton.none)
        //        setupIconsButton(selectedIcon: viewModel.icon ?? IconsButton.none)
        setupIconsStartButton(reaction: ReactionType.best)
        setupIconsButton(reaction: ReactionType.best)
    }
    
    //    private func setupIconsStartButton(selectedIcon: IconsButton) {
    //        iconsStartButton.setImage(selectedIcon.selectedButtonIconsImage, for: .normal)
    //    }
    
    private func setupIconsStartButton(reaction: ReactionType) {
        iconsStartButton.setImage(reaction.selectedButtonImage, for: .normal)
    }
    
//    private func setupIconsButton(selectedIcon: IconsButton) {
//        for button in iconsButtonCollection {
//            button.isSelected = button.tag == selectedIcon.rawValue ? true : false
//        }
//    }
    
    private func setupIconsButton(reaction: ReactionType) {
        for button in iconsButtonCollection {
            button.isSelected = button.tag == reaction.tag ? true : false
        }
    }
    
    //    func setupIconsView(selectedButtonIcons: [SelectedIconButton]) {
    //        if selectedButtonIcons.isEmpty {
    //            let iconsView = NoIconsView(frame: .zero)
    //            iconsBackgroundView.addSubview(iconsView)
    //            iconsView.frame = iconsBackgroundView.bounds
    //        } else if selectedButtonIcons.count == 1 {
    //            let iconsView = OneIconView(frame: .zero)
    //            iconsBackgroundView.addSubview(iconsView)
    //            iconsView.frame = iconsBackgroundView.bounds
    //            iconsView.setupText(selectedIcons: selectedButtonIcons)
    //        } else {
    //            let iconsView = ManyIconsView(frame: .zero)
    //            iconsBackgroundView.addSubview(iconsView)
    //            iconsView.frame = iconsBackgroundView.bounds
    //            iconsView.setupUI(selectedIcons: selectedButtonIcons)
    //        }
    //    }
    
    func setupTestIconsView(reactions: [Reaction]) {
        if reactions.isEmpty {
            let iconsView = NoIconsView(frame: .zero)
            iconsBackgroundView.addSubview(iconsView)
            iconsView.frame = iconsBackgroundView.bounds
        } else if reactions.count == 1 {
            let iconsView = OneIconView(frame: .zero)
            iconsBackgroundView.addSubview(iconsView)
            iconsView.frame = iconsBackgroundView.bounds
            iconsView.setupTestUI(reactions: reactions)
        } else {
            let iconsView = ManyIconsView(frame: .zero)
            iconsBackgroundView.addSubview(iconsView)
            iconsView.frame = iconsBackgroundView.bounds
            iconsView.setupTestUI(reactions: reactions)
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
//            closeIconsButton(isSelected: self.nowSelectedButtonIcon)
            closeIconsButton(isSelected: self.nowSelectedReaction)
        } else {
            sender.isSelected = true
            openIconsButton()
        }
    }
    
    @IBAction private func touchUpIconsButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            
//            let isSelectedIcon: IconsButton = isSelectedIcons(button: sender)
//            deleteSeletedIcon?(isSelectedIcon)
//            nowSelectedButtonIcon = IconsButton.none
            
            deleteSeletedIcon?()
            nowSelectedReaction = ReactionType.none
        } else {
            sender.isSelected = true
            deselectAnotherButton(button: sender)
            
//            let isSelectedIcon: IconsButton = isSelectedIcons(button: sender)
//            addSelectedIcon?(isSelectedIcon)
//            nowSelectedButtonIcon = isSelectedIcon
            
            let isSelectedReaction: ReactionType = isSelectedReaction(button: sender)
            addSelectedIcon?(isSelectedReaction)
            nowSelectedReaction = isSelectedReaction
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
    
//    private func isSelectedIcons(button: UIButton) -> IconsButton {
//        guard let button = IconsButton(rawValue: button.tag) else {
//            return .none
//        }
//        return button
//    }
    
    private func isSelectedReaction(button: UIButton) -> ReactionType {
        var reaction = ReactionType.none
        ReactionType.allCases.forEach {
            if $0.tag == button.tag {
                reaction = $0
            }
        }
        return reaction
    }
    
//    private func openIconsButton() {
//        let contentViewWidth = self.contentView.frame.width
//        iconsButtonXPointConstraint.forEach {
//            let constraint: NSLayoutConstraint = $0
//            let constant: CGFloat? = {
//                if constraint.identifier == "likeButton" {
//                    return IconsButton.likeButton.distRatioFromStartButton * contentViewWidth
//                } else if constraint.identifier == "angryButton" {
//                    return IconsButton.angryButton.distRatioFromStartButton * contentViewWidth
//                } else if constraint.identifier == "amazingButton" {
//                    return IconsButton.amazingButton.distRatioFromStartButton * contentViewWidth
//                } else if constraint.identifier == "sadButton" {
//                    return IconsButton.sadButton.distRatioFromStartButton * contentViewWidth
//                } else if constraint.identifier == "bestButton" {
//                    return IconsButton.bestButton.distRatioFromStartButton * contentViewWidth
//                } else {
//                    return nil
//                }
//            }()
//
//            UIView.animate(withDuration: 0.5) { [weak self] in
//                guard let self = self, let constant = constant else { return }
//                constraint.constant = constant
//                self.layoutIfNeeded()
//            }
//        }
//    }
    
    private func openIconsButton() {
        let contentViewWidth = self.contentView.frame.width
        iconsButtonXPointConstraint.forEach {
            let constraint: NSLayoutConstraint = $0
            let constant: CGFloat? = {
                if constraint.identifier == "likeButton" {
                    return ReactionType.like.distRatioFromStartButton * contentViewWidth
                } else if constraint.identifier == "angryButton" {
                    return ReactionType.angry.distRatioFromStartButton * contentViewWidth
                } else if constraint.identifier == "amazingButton" {
                    return ReactionType.amazing.distRatioFromStartButton * contentViewWidth
                } else if constraint.identifier == "sadButton" {
                    return ReactionType.sad.distRatioFromStartButton * contentViewWidth
                } else if constraint.identifier == "bestButton" {
                    return ReactionType.best.distRatioFromStartButton * contentViewWidth
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
    
//    private func closeIconsButton(isSelected icon: IconsButton) {
//        iconsButtonXPointConstraint.forEach {
//            let constraint: NSLayoutConstraint = $0
//            let constant: CGFloat = IconsButton.none.distRatioFromStartButton
//
//            UIView.animate(withDuration: 0.5) { [weak self] in
//                guard let self = self else { return }
//
//                constraint.constant = constant
//                self.layoutIfNeeded()
//            } completion: { [weak self] _ in
//                guard let self = self else { return }
//
//                self.delegate?.iconButtonAnimationIsClosed()
//                self.iconsStartButton.isSelected = false
//
//                guard let selectedIconImage = icon.selectedButtonIconsImage else { return }
//                self.iconsStartButton.setImage(selectedIconImage, for: .normal)
//            }
//        }
//    }
    
    private func closeIconsButton(isSelected reaction: ReactionType) {
        iconsButtonXPointConstraint.forEach {
            let constraint: NSLayoutConstraint = $0
            let constant: CGFloat = 0
            
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self = self else { return }
                
                constraint.constant = constant
                self.layoutIfNeeded()
            } completion: { [weak self] _ in
                guard let self = self else { return }
                
                self.delegate?.iconButtonAnimationIsClosed()
                self.iconsStartButton.isSelected = false
                
                guard let selectedButtonImage = reaction.selectedButtonImage else { return }
                self.iconsStartButton.setImage(selectedButtonImage, for: .normal)
            }
        }
    }
}

enum IconsButton: Int, CaseIterable {
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
    
    var description: String? {
        switch self {
        case .likeButton:
            return "like"
        case .angryButton:
            return "angey"
        case .amazingButton:
            return "amazing"
        case .sadButton:
            return "sad"
        case .bestButton:
            return "best"
        case .none:
            return nil
        }
    }
}

enum ReactionType: String, CaseIterable {
    case like = "like"
    case angry = "angry"
    case amazing = "amazing"
    case sad = "sad"
    case best = "best"
    case none = "none"
    
    var distRatioFromStartButton: CGFloat {
        switch self {
        case .like:
            return -(73/375)
        case .angry:
            return -(121/375)
        case .amazing:
            return -(169/375)
        case .sad:
            return -(217/375)
        case .best:
            return -(265/375)
        case .none:
            return 0
        }
    }
    
    var selectedButtonImage: UIImage? {
        switch self {
        case .like:
            return UIImage(named: "icn=like_y")
        case .angry:
            return UIImage(named: "icn=angry_y")
        case .amazing:
            return UIImage(named: "icn=amazing_y")
        case .sad:
            return UIImage(named: "icn=sad_y")
        case .best:
            return UIImage(named: "icn=best_y")
        case .none:
            return UIImage(named: "icn=best")
        }
    }
    
    var deSelectedButtonImage: UIImage? {
        switch self {
        case .like:
            return UIImage(named: "icn=like")
        case .angry:
            return UIImage(named: "icn=angry")
        case .amazing:
            return UIImage(named: "icn=amazing")
        case .sad:
            return UIImage(named: "icn=sad")
        case .best:
            return UIImage(named: "icn=best")
        case .none:
            return UIImage(named: "icn=best")
        }
    }
    
    var selectedImageViewImage: UIImage? {
        switch self {
        case .like:
            return UIImage(named: "img=like")
        case .angry:
            return UIImage(named: "img=angry")
        case .amazing:
            return UIImage(named: "img=amazing")
        case .sad:
            return UIImage(named: "img=sad")
        case .best:
            return UIImage(named: "img=best")
        case .none:
            return nil
        }
    }
    
    var tag: Int {
        switch self {
        case .like:
            return 0
        case .angry:
            return 1
        case .amazing:
            return 2
        case .sad:
            return 3
        case .best:
            return 4
        case .none:
            return 5
        }
    }
}
