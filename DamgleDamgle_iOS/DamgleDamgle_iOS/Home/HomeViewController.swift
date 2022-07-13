//
//  HomeViewController.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/12.
//

import UIKit

class HomeViewController: UIViewController, BaseViewController {
    
    @IBOutlet private weak var currentAddressLabel: UILabel!
    @IBOutlet private weak var monthlyPaintingBGView: UIView!
    @IBOutlet private weak var monthlyPaintingRemainingTimeLabel: UILabel!
    
    fileprivate enum MonthlyPaintingMode: String {
        case moreThanOneHour = "grey1000"
        case lessThanOneHour = "orange500"
    }
    
    let (originWidth, originHeight) : (CGFloat, CGFloat) = (UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    
    fileprivate var currentPaintingMode: MonthlyPaintingMode = .moreThanOneHour {
        didSet {
            monthlyPaintingBGView.backgroundColor = UIColor(named: currentPaintingMode.rawValue)
        }
    }
    
// MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setChildPostView()
    }

// MARK: - @IBAction
    @IBAction private func myPageButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction private func refreshButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction private func currentLocationButtonTapped(_ sender: UIButton) {
    }
    
// MARK: - UDF
    func layoutView() { }
    
    func setUpView() {
        monthlyPaintingBGView.layer.cornerRadius = 8
    }
    
    func setChildPostView() {
        let childView: PostViewController = PostViewController()
        childView.view.frame = CGRect(x: 0, y: self.originHeight * 0.85, width: self.originWidth, height: self.originHeight * 0.15)
        self.addChild(childView)
        
        self.view.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
}
