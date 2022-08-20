//
//  CustomMarker.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/08/21.
//

import UIKit

class CustomMarker: UIView, NibBased {
    @IBOutlet private weak var bubbleBackgroundImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
}
