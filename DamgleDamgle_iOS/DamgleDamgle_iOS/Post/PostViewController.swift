//
//  PostViewController.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/12.
//

import UIKit

final class PostViewController: UIViewController {
    
    @IBOutlet private weak var myStoryGuideLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    
// MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpView()
    }
    
// MARK: - @IBAction
    @IBAction private func swipeUpDown(_ sender: UISwipeGestureRecognizer) {
        let originWidth: CGFloat = UIScreen.main.bounds.width
        let originHeight: CGFloat = UIScreen.main.bounds.height
        
        UIView.animate(withDuration: 0.3) {
            switch sender.direction {
            case .up:
                self.view.frame = CGRect(x: 0, y: originHeight * 0.05, width: originWidth, height: originHeight * 0.95)
                self.myStoryGuideLabel.isHidden = true
                self.view.layoutIfNeeded()
            case .down:
                self.view.frame = CGRect(x: 0, y: originHeight * 0.85, width: originWidth, height: originHeight * 0.15)
                self.myStoryGuideLabel.isHidden = false
                self.view.layoutIfNeeded()
            default:
                break
            }
        }
    }
    
// MARK: - UDF
    func layoutView() { }
    
    func setUpView() {
        myStoryGuideLabel.isHidden = false
        
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
}
