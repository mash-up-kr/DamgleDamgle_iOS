//
//  oneIconView.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/16.
//

import UIKit

final class OneIconView: UIView, NibBased {
    
    @IBOutlet private weak var iconImageView: RotatableImageView!
    @IBOutlet private weak var iconCountLabel: RoundLabel!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    func setupView(reactions: [ReactionSummary]) {
        guard let reaction = reactions.first, let reactionImage = ReactionType(rawValue: reaction.type)?.selectedImageViewImage else { return }
        iconCountLabel.text = "\(reaction.count)"
        iconImageView.image = reactionImage
    }
}
