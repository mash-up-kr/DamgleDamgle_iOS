//
//  ListEmptyView.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/17.
//

import UIKit

final class ListEmptyView: UIView, Reusable, NibBased {
    static var nibName: String {
        String(describing: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        awakeFromNib()
    }
}
