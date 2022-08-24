//
//  CustomMarker.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/08/21.
//

import UIKit
import NMapsMap

class CustomMarker: UIView, NibBased {
    @IBOutlet private weak var bubbleBackgroundImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var storyCountLabel: UILabel!
    @IBOutlet weak var markerView: UIView!
    
    enum MarkerType {
        case my
        case notMy
    }
    
    var currentMarkerType: MarkerType = .my {
        didSet {
            switch currentMarkerType {
            case .my:
                bubbleBackgroundImageView.image = UIImage(named: "write_me_bubble") ?? UIImage.checkmark
            case .notMy:
                bubbleBackgroundImageView.image = UIImage(named: "write_other_bubble") ?? UIImage.checkmark
            }
        }
    }
    
    var currentIcon: MainIcon = .none {
        didSet {
            iconImageView.image = UIImage(named: currentIcon.rawValue) ?? UIImage.checkmark
        }
    }
    
    var storyCount = 0 {
        didSet {
            markerView.isHidden = storyCount == 1
            if storyCount <= 99 {
                storyCountLabel.text = "\(storyCount)"
            } else {
                storyCountLabel.text = "99+"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    func updateMarker(markerType: MarkerType, iconType: MainIcon, storyCount: Int) {
        currentMarkerType = markerType
        currentIcon = iconType
        self.storyCount = storyCount
    }
}
