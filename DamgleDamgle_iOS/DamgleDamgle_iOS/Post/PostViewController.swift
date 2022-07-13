//
//  PostViewController.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/12.
//

import UIKit

final class PostViewController: UIViewController, BaseViewController {
    
    @IBOutlet private weak var myStoryGuideLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    
    let (originWidth, originHeight) : (CGFloat, CGFloat) = (UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    
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
        UIView.animate(withDuration: 0.3) {
            switch sender.direction {
            case .up:
                self.view.frame = CGRect(x: 0, y: self.originHeight * 0.05, width: self.originWidth, height: self.originHeight * 0.95)
                self.myStoryGuideLabel.isHidden = true
                self.view.layoutIfNeeded()
            case .down:
                self.view.frame = CGRect(x: 0, y: self.originHeight * 0.85, width: self.originWidth, height: self.originHeight * 0.15)
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
        self.view.layer.isOpaque = false
        self.view.layer.masksToBounds = true
    }
}
