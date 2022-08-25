//
//  PostTableViewCell.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/03.
//

import UIKit

protocol TableViewCellDelegate: AnyObject {
    func endReactionButtonAnimation(reaction: ReactionType)
}

final class PostTableViewCell: UITableViewCell, Reusable {
    
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
    
    weak var delegate: TableViewCellDelegate?
    var addSelectedIcon: ((ReactionType) -> Void)?
    var deleteSeletedIcon: (() -> Void)?
    var postReport: (() -> Void)?
    var type: StoryType?
    private var nowSelectedReaction: ReactionType = ReactionType.none {
        didSet {
            closeIconsButton(isSelected: nowSelectedReaction)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
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
        reportButton.isHidden = false
    }
    
    private func setupView() {
        iconsStartButton.imageView?.contentMode = .scaleAspectFit
    }
    
    func setupUI(viewModel: Story?) {
        guard let viewModel = viewModel, var address1 = viewModel.address1, var address2 = viewModel.address2 else { return }
        
        if address1 == "" {
            address1 = "역삼동"
            address2 = "테헤란로 141"
        }
        placeAddressLabel.text = "\(address1)\n\(address2)"
        userNameLabel.text = viewModel.nickname
        checkMeLabel.text = viewModel.isMine ? " • ME" : ""
        timeLabel.text = viewModel.offsetTimeText
        contentLabel.text = viewModel.content
        setupIconsView(reactions: viewModel.reactionSummary)
        setupIconsStartButton(reaction: viewModel.reactionOfMine)
        setupIconsButton(reaction: viewModel.reactionOfMine)
        reportButton.isHidden = type == .myStory ? true : false
    }
    
    private func setupIconsStartButton(reaction: MyReaction?) {
        guard let reaction = reaction else { return }
        iconsStartButton.setImage(ReactionType(rawValue: reaction.type)?.selectedButtonImage, for: .normal)
    }
    
    private func setupIconsButton(reaction: MyReaction?) {
        guard let reaction = reaction else { return }
        
        for button in iconsButtonCollection {
            let reactionType = ReactionType(rawValue: reaction.type)
            button.isSelected = button.tag == reactionType?.tag ? true : false
        }
    }
    
    private func setupIconsView(reactions: [ReactionSummary]) {
        let filterReactions = reactions.filter { $0.count != 0 }
        
        if filterReactions.isEmpty {
            let iconsView = NoIconsView(frame: .zero)
            iconsBackgroundView.addSubview(iconsView)
            iconsView.frame = iconsBackgroundView.bounds
        } else if filterReactions.count == 1 {
            let iconsView = OneIconView(frame: .zero)
            iconsBackgroundView.addSubview(iconsView)
            iconsView.frame = iconsBackgroundView.bounds
            iconsView.setupView(reactions: filterReactions)
        } else {
            let iconsView = ManyIconsView(frame: .zero)
            iconsBackgroundView.addSubview(iconsView)
            iconsView.frame = iconsBackgroundView.bounds
            iconsView.setupView(reactions: reactions)
        }
    }
    
    @IBAction private func touchUpiconStartButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            closeIconsButton(isSelected: self.nowSelectedReaction)
        } else {
            sender.isSelected = true
            openIconsButton()
        }
    }
    
    @IBAction private func touchUpIconsButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            
            deleteSeletedIcon?()
            nowSelectedReaction = ReactionType.none
        } else {
            sender.isSelected = true
            deselectAnotherButton(button: sender)
            
            let isSelectedReaction: ReactionType = isSelectedReaction(button: sender)
            addSelectedIcon?(isSelectedReaction)
            nowSelectedReaction = isSelectedReaction
        }
    }
    
    @IBAction private func reportButtonDidTap(_ sender: UIButton) {
        postReport?()
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
    
    private func isSelectedReaction(button: UIButton) -> ReactionType {
        var reaction = ReactionType.none
        ReactionType.allCases.forEach {
            if $0.tag == button.tag {
                reaction = $0
            }
        }
        return reaction
    }
    
    private func openIconsButton() {
        guard let selectedIconImage = nowSelectedReaction.inActiveButtonimage else { return }
        iconsStartButton.setImage(selectedIconImage, for: .selected)
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.iconsButtonXPointConstraint.forEach {
                $0.constant = self.getConstraintConstant(constraint: $0) ?? 0
            }
            self.layoutIfNeeded()
        }
    }
    
    private func closeIconsButton(isSelected reaction: ReactionType) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.iconsButtonXPointConstraint.forEach {
                $0.constant = 0
            }
            self.layoutIfNeeded()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.delegate?.endReactionButtonAnimation(reaction: reaction)
        })
    }
    
    private func getConstraintConstant(constraint: NSLayoutConstraint) -> CGFloat? {
        let contentViewWidth = self.contentView.frame.width
        switch constraint.identifier {
        case ReactionType.like.rawValue:
            return ReactionType.like.distRatioFromStartButton * contentViewWidth
        case ReactionType.angry.rawValue:
            return ReactionType.angry.distRatioFromStartButton * contentViewWidth
        case ReactionType.amazing.rawValue:
            return ReactionType.amazing.distRatioFromStartButton * contentViewWidth
        case ReactionType.sad.rawValue:
            return ReactionType.sad.distRatioFromStartButton * contentViewWidth
        case ReactionType.best.rawValue:
            return ReactionType.best.distRatioFromStartButton * contentViewWidth
        default:
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
    
    var inActiveButtonimage: UIImage? {
        switch self {
        case .like:
            return UIImage(named: "icn=like_inactive")
        case .angry:
            return UIImage(named: "icn=angry_inactive")
        case .amazing:
            return UIImage(named: "icn=amazing_inactive")
        case .sad:
            return UIImage(named: "icn=sad_inactive")
        case .best:
            return UIImage(named: "icn=best_inactive")
        case .none:
            return UIImage(named: "icn=best_inactive")
        }
    }
    
    var toastMessageTitle: String? {
        switch self {
        case .like:
            return "좋아요 이모지로 수정되었습니다!"
        case .angry:
            return "화나요 이모지로 수정되었습니다!"
        case .amazing:
            return "놀라워요 이모지로 수정되었습니다!"
        case .sad:
            return "슬퍼요 이모지로 수정되었습니다!"
        case .best:
            return "최고에요 이모지로 수정되었습니다!"
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
