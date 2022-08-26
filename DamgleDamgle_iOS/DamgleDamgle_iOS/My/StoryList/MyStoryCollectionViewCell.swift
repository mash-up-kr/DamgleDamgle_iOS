//
//  MyStoryCollectionViewCell.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/29.
//

import UIKit

final class MyStoryCollectionViewCell: UICollectionViewCell, Reusable {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var reactionCountLabel: UILabel! {
        didSet {
            reactionCountLabel.layer.borderWidth = 0.5
            reactionCountLabel.layer.borderColor = UIColor(named: "grey1000")?.cgColor
            reactionCountLabel.layer.cornerRadius = 8.0
            reactionCountLabel.layer.masksToBounds = true
        }
    }

    func configure(story: Story?) {
        addressLabel.text = "\(story?.address1 ?? "열심히 공사중인")\n\(story?.address2 ?? "담글이네")"
        imageView.image = ReactionType(rawValue: story?.mostReaction ?? "")?.selectedImageViewImage ?? UIImage(named: "img=empty")
        reactionCountLabel.text = "\(story?.reactionAllCount ?? 0)"
        reactionCountLabel.isHidden = story?.reactionAllCount == 0
        timeLabel.text = story?.offsetTimeText
    }
}
