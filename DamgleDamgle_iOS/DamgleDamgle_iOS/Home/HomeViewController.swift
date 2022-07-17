//
//  HomeViewController.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/12.
//

import UIKit

final class HomeViewController: UIViewController {    
    @IBOutlet private weak var currentAddressLabel: UILabel!
    @IBOutlet private weak var monthlyPaintingBGView: UIView! {
        didSet {
            monthlyPaintingBGView.layer.cornerRadius = 8
        }
    }
    @IBOutlet private weak var monthlyPaintingRemainingTimeLabel: UILabel!
    
    private enum MonthlyPaintingMode: String {
        case moreThanOneHour = "grey1000"
        case lessThanOneHour = "orange500"
    }
    
    private var currentPaintingMode: MonthlyPaintingMode = .moreThanOneHour {
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
        let myViewController = MyViewController.instantiate()
        myViewController.modalPresentationStyle = .overFullScreen
        present(myViewController, animated: true)
    }
    
    @IBAction private func refreshButtonTapped(_ sender: UIButton) {
        // TODO: 새로 고침
    }
    
    @IBAction private func currentLocationButtonTapped(_ sender: UIButton) {
        // TODO: 현재 위치로 이동
    }
    
// MARK: - UDF
    func setUpView() {
        monthlyPaintingBGView.layer.cornerRadius = 8
    }
    
    func setChildPostView() {
        let originWidth: CGFloat = UIScreen.main.bounds.width
        let originHeight: CGFloat = UIScreen.main.bounds.height
        
        let childView: PostViewController = PostViewController()
        self.view.addSubview(childView.view)
        childView.view.frame = CGRect(x: 0, y: originHeight * 0.85, width: originWidth, height: originHeight * 0.15)
        self.addChild(childView)
        
        childView.didMove(toParent: self)
    }
}
