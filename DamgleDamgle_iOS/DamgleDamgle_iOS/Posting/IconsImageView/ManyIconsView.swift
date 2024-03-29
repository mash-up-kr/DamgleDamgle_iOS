//
//  ManyIconsView.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/16.
//

import UIKit

final class ManyIconsView: UIView, NibBased {
    
    @IBOutlet private var iconsLabelCollection: [RoundLabel]!
    @IBOutlet private var iconsImageViewCollection: [RotatableImageView]!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    func setupView(reactions: [ReactionSummary]) {
        setupLabel(reactions: reactions)
        setupImageView(reactions: reactions)
    }
    
    private func setupLabel(reactions: [ReactionSummary]) {
        iconsLabelCollection.forEach { label in
            label.isHidden = true
        }
        
        for (id, content) in reactions.enumerated() {
            iconsLabelCollection.forEach {
                if $0.tag == id && content.count > 0 {
                    $0.isHidden = false
                    $0.text = "\(content.count)"
                }
            }
        }
    }
    
    private func setupImageView(reactions: [ReactionSummary]) {
        iconsImageViewCollection.forEach { imageView in
            imageView.isHidden = true
        }
        
        for (id, content) in reactions.enumerated() {
            var reaction = ReactionType.none
            for reactionType in ReactionType.allCases {
                if reactionType.rawValue == content.type {
                    reaction = reactionType
                    break
                }
            }
            
            iconsImageViewCollection.forEach {
                if $0.tag == id && content.count > 0 {
                    $0.isHidden = false
                    $0.image = reaction.selectedImageViewImage
                }
            }
        }
    }
}
