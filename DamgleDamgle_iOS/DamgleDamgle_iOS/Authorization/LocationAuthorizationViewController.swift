//
//  LocationAuthorizationViewController.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/06.
//

import UIKit

final class LocationAuthorizationViewController: UIViewController, BaseViewController {
    @IBOutlet private weak var guideLabel: UILabel!
    
    let fullDimView: UIView = FullDimView()

// MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        layoutView()
        setUpView()
    }
    
// MARK: - UDF
    func layoutView() {
        view.addSubview(fullDimView)
        
        let superViewFrame: CGRect = UIScreen.main.bounds
        fullDimView.frame = CGRect(x: 0, y: 0, width: superViewFrame.width, height: superViewFrame.height)
    }
    
    func setUpView() {
        guideLabel.font = DamgleFont.bodyBold18.font
    }
}
