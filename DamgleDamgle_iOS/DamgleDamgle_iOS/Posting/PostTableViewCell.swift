//
//  PostTableViewCell.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/03.
//

import UIKit

protocol TableViewCellDelegate: AnyObject {
    func endReactionButtonAnimation(reaction: ReactionType, wasEmpty: Bool, isChange: Bool, storyID: String)
}

final class PostTableViewCell: UITableViewCell, Reusable {
    
    @IBOutlet private weak var placeAddressLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var checkMeLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var iconsStartButton: UIButton!
    @IBOutlet private weak var reportButton: UIButton!
    @IBOutlet private weak var noIconsView: NoIconsView!
    @IBOutlet private weak var oneIconView: OneIconView!
    @IBOutlet private weak var manyIconsView: ManyIconsView!
    @IBOutlet private var iconsButtonCollection: [SelectableButton]!
    @IBOutlet private var iconsButtonXPointConstraint: [NSLayoutConstraint]!
    
    weak var delegate: TableViewCellDelegate?
    private var viewModel = PostingTableViewCellViewModel()
    var addSelectedIcon: ((ReactionType) -> Void)?
    var deleteSeletedIcon: (() -> Void)?
    var postReport: (() -> Void)?
    private var nowSelectedReaction: ReactionType = .none {
        didSet {
            closeIconsButton(isSelected: nowSelectedReaction, wasEmpty: (oldValue == ReactionType.none) && (nowSelectedReaction != ReactionType.none))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

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
    
    func setupUI(story: Story?) {
        guard let story = story, var address1 = story.address1, var address2 = story.address2 else { return }
        
        if address1 == "" {
            address1 = "담글이네"
            address2 = "찾는 중"
        }
        self.viewModel.updateStoryModel(Story: story)
        placeAddressLabel.text = "\(address1)\n\(address2)"
        userNameLabel.text = story.nickname
        checkMeLabel.text = story.isMine ? " • ME" : ""
        timeLabel.text = story.offsetTimeText
        contentLabel.text = story.content
        setupIconsView(reactions: story.reactionSummary)
        setupIconsStartButton(reaction: story.reactionOfMine)
        setupIconsButton(reaction: story.reactionOfMine)
        reportButton.isHidden = story.isMine
    }
    
    private func setupIconsStartButton(reaction: MyReaction?) {
        if let reaction = reaction {
            iconsStartButton.isSelected = false
            iconsStartButton.setImage(ReactionType(rawValue: reaction.type)?.selectedButtonImage, for: .normal)
        } else {
            iconsStartButton.isSelected = false
            iconsStartButton.setImage(ReactionType.none.selectedButtonImage, for: .normal)
        }
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
            
            noIconsView.isHidden = false
            oneIconView.isHidden = true
            manyIconsView.isHidden = true
        } else if filterReactions.count == 1 {
            
            noIconsView.isHidden = true
            oneIconView.isHidden = false
            manyIconsView.isHidden = true
            
            oneIconView.setupView(reactions: filterReactions)
        } else {
            
            noIconsView.isHidden = true
            oneIconView.isHidden = true
            manyIconsView.isHidden = false
            
            manyIconsView.setupView(reactions: reactions)
        }
    }
    
    @IBAction private func touchUpiconStartButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            closeIconsButton(isSelected: nowSelectedReaction, isChange: false)
        } else {
            sender.isSelected = true
            openIconsButton()
        }
    }
    
    @IBAction private func touchUpIconsButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        
            nowSelectedReaction = ReactionType.none
            
            guard let viewModel = viewModel.storyModel else { return }
            self.viewModel.deleteReaction(storyID: viewModel.id) { result in
                switch result {
                case .success(let story):
                    DispatchQueue.main.async {
                        self.setupUI(story: story)
                    }
                case .failure(let error):
                    // TODO: 실패했을때 대응방법 적용예정
                    print(error.localizedDescription)
                }
            }
        } else {
            sender.isSelected = true
            deselectAnotherButton(button: sender)
            
            let isSelectedReaction: ReactionType = isSelectedReaction(button: sender)
            nowSelectedReaction = isSelectedReaction
            
            guard let viewModel = viewModel.storyModel else { return }
            self.viewModel.postReaction(storyID: viewModel.id, type: isSelectedReaction.rawValue) { result in
                switch result {
                case .success(let story):
                    DispatchQueue.main.async {
                        self.setupUI(story: story)
                    }
                case .failure(let error):
                    // TODO: 실패했을때 대응방법 적용예정
                    print(error.localizedDescription)
                }
            }
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
    
    private func closeIconsButton(isSelected reaction: ReactionType, wasEmpty: Bool = false, isChange: Bool = true) {
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.iconsButtonXPointConstraint.forEach {
                $0.constant = 0
            }
            self.layoutIfNeeded()
        }
                
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: { [weak self] in
            guard let self = self, let id = self.viewModel.storyModel?.id else { return }
            self.delegate?.endReactionButtonAnimation(reaction: reaction, wasEmpty: wasEmpty, isChange: isChange, storyID: id)
        })
    }
    
    private func getConstraintConstant(constraint: NSLayoutConstraint) -> CGFloat? {
        let contentViewWidth = self.contentView.frame.width
        guard let id = constraint.identifier else { return 0 }
        switch ReactionType(rawValue: id) {
        case .like:
            return ReactionType.like.distRatioFromStartButton * contentViewWidth
        case .angry:
            return ReactionType.angry.distRatioFromStartButton * contentViewWidth
        case .amazing:
            return ReactionType.amazing.distRatioFromStartButton * contentViewWidth
        case .sad:
            return ReactionType.sad.distRatioFromStartButton * contentViewWidth
        case .best:
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
    
    var firstReactionTitle: String {
        "담글에 공감하셨어요!"
    }
    
    var removeReactionTitle: String {
        "공감이 취소되었어요."
    }
    
    var toastMessageTitle: String? {
        switch self {
        case .like:
            return "좋아요 이모지로 수정되었어요!"
        case .angry:
            return "화나요 이모지로 수정되었어요!"
        case .amazing:
            return "놀라워요 이모지로 수정되었어요!"
        case .sad:
            return "슬퍼요 이모지로 수정되었어요!"
        case .best:
            return "최고에요 이모지로 수정되었어요!"
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
