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
    
    func setupUI(reactions: [Reaction]) {
        guard let reaction = reactions.first else { return }
        // TODO: 서버에서 reaction값 떨궈주면 셋팅 예정
//        iconCountLabel.text = "\(reaction.count)"
        iconCountLabel.text = "1"

        guard let reactionImage = ReactionType(rawValue: reaction.type)?.selectedImageViewImage else { return }
        iconImageView.image = reactionImage
    }
    
    func setupTestUI(reactions: [Reaction]) {
        guard let reaction = reactions.first else { return }
        // TODO: 서버에서 reaction값 떨궈주면 셋팅 예정
//        iconCountLabel.text = "\(reaction.count)"
        iconCountLabel.text = "1"

        guard let reactionImage = ReactionType(rawValue: reaction.type)?.selectedImageViewImage else { return }
        iconImageView.image = reactionImage
    }

    // MARK: - InterfaceBuilder Links
    @IBOutlet private weak var iconImageView: RotatableImageView!
    @IBOutlet private weak var iconCountLabel: RoundLabel!
}
