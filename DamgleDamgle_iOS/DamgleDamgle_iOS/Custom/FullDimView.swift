//
//  FullDimView.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/06.
//

import UIKit

final class FullDimView: UIView, BaseView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    func initView() {
        self.backgroundColor = UIColor(named: "dimViewColor")
    }
    
    func setUpView() {}
}
