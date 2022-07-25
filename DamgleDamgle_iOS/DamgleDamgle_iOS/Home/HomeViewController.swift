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
    
    private let originWidth: CGFloat = UIScreen.main.bounds.width
    private let originHeight: CGFloat = UIScreen.main.bounds.height
    private let postViewHeightRatio = 0.85
    
// MARK: - override
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if children.isEmpty {
            setChildPostView()
        }
    }
    
    func resetChildView() {
        if let childrenViewController = children.first as? PostViewController {
            childrenViewController.view.frame = CGRect(
                x: 0,
                y: originHeight * postViewHeightRatio,
                width: originWidth,
                height: originHeight * (1 - postViewHeightRatio)
            )
            childrenViewController.setUpView()
        }
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
    func setChildPostView() {
        let childView: PostViewController = PostViewController()
        view.addSubview(childView.view)
        childView.view.frame = CGRect(
            x: 0,
            y: originHeight * postViewHeightRatio,
            width: originWidth,
            height: originHeight * (1 - postViewHeightRatio)
        )
        addChild(childView)
        
        childView.didMove(toParent: self)
    }
}
