//
//  ManyIconsView.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/16.
//

import UIKit

final class ManyIconsView: UIView, NibBased {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    func setupUI(reactions: [Reaction]) {
        setupLabel(reactions: reactions)
        setupImageView(reactions: reactions)
    }
    
    private func setupLabel(reactions: [Reaction]) {
        for (id, content) in reactions.enumerated() {
            iconsLabelCollection.forEach {
                if $0.tag == id {
                    $0.isHidden = false
                    // TODO: 서버에서 Reaction 모델에 count 추가할 예정
//                    $0.text = "\(content.count)"
                    $0.text = "1"
                }
            }
        }
    }
    
    private func setupImageView(reactions: [Reaction]) {
        for (id, content) in reactions.enumerated() {
            var reaction = ReactionType.none
            for reactionType in ReactionType.allCases {
                if reactionType.rawValue == content.type {
                    reaction = reactionType
                    break
                }
            }
            
            iconsImageViewCollection.forEach {
                if $0.tag == id {
                    $0.isHidden = false
                    $0.image = reaction.selectedImageViewImage
                }
            }
        }
    }

    // MARK: - InterfaceBuilder Links

    @IBOutlet private var iconsLabelCollection: [RoundLabel]!
    @IBOutlet private var iconsImageViewCollection: [RotatableImageView]!
}
