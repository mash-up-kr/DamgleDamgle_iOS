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
    
    // 서버데이터를 사용했을 때 사용하는 함수
    func setupTestUI(reactions: [Reaction]) {
        let reactionsTag = reactions.map { ReactionType(rawValue: $0.type)?.tag }
        // TODO: 서버에서 reaction Count값 떨궈주면 매칭 -> 임시 Mock 데이터 적용
//        let reactionCount = reactions.map { $0.Count }
        let reactionCount = 2

        iconsLabelCollection.forEach {
            if reactionsTag.contains($0.tag) {
                $0.isHidden = false

                guard let index = reactionsTag.firstIndex(of: $0.tag) else { return }
                // TODO: 서버에서 reaction Count값 떨궈주면 매칭 -> 임시 Mock 데이터 적용
//                $0.text = "\(reactionsCount[index])"
                $0.text = "\(reactionCount)"
            } else {
                $0.isHidden = true
            }
        }

        iconsImageViewCollection.forEach {
            if reactionsTag.contains($0.tag) {
                $0.isHidden = false
            } else {
                $0.isHidden = true
            }
        }
    }
    
    // 서버데이터를 사용했을 때 사용하는 함수
    func setupTestUI(reactions: [Reaction]) {
        let reactionsTag = reactions.map { ReactionType(rawValue: $0.type)?.tag }
        // TODO: 서버에서 reaction Count값 떨궈주면 매칭 -> 임시 Mock 데이터 적용
//        let reactionCount = reactions.map { $0.Count }
        let reactionCount = 2

        iconsLabelCollection.forEach {
            if reactionsTag.contains($0.tag) {
                $0.isHidden = false

                guard let index = reactionsTag.firstIndex(of: $0.tag) else { return }
                // TODO: 서버에서 reaction Count값 떨궈주면 매칭 -> 임시 Mock 데이터 적용
//                $0.text = "\(reactionsCount[index])"
                $0.text = "\(reactionCount)"
            } else {
                $0.isHidden = true
            }
        }

        iconsImageViewCollection.forEach {
            if reactionsTag.contains($0.tag) {
                $0.isHidden = false
            } else {
                $0.isHidden = true
            }
        }
    }

    // MARK: - InterfaceBuilder Links

    @IBOutlet private var iconsLabelCollection: [RoundLabel]!
    @IBOutlet private var iconsImageViewCollection: [RotatableImageView]!
}
