//
//  MyViewController.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/16.
//

import UIKit
import Lottie

final class MyViewController: UIViewController, StoryboardBased {
    static var storyboard: UIStoryboard {
        UIStoryboard(name: "My", bundle: nil)
    }
    
    @IBOutlet private weak var nicknameLabel: UILabel! {
        didSet {
            nicknameLabel.text = "로딩중인 1004번째 담글이"
        }
    }
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var listButton: UIButton!
    @IBOutlet private weak var settingButton: UIButton!
    @IBOutlet private weak var buttonBackgroundListLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var buttonBackgroundListTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var buttonBackgroundView: UIView! {
        didSet {
            buttonBackgroundView.layer.cornerRadius = 8.0
            buttonBackgroundView.layer.masksToBounds = true
        }
    }
    
    private let fullDimView = FullDimView()
    private let refreshLottieName = "refreshLottie"
    
    private lazy var animationView = Lottie.AnimationView(name: refreshLottieName)

    private let viewModel = MyViewModel()
    
    private let listViewController = MyStoryListViewController.instantiate()
    private let settingViewController = SettingViewController.instantiate()
    
    private var pages: [UIViewController] = []
    private var currentPage = 0
    
    private lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        pageViewController.dataSource = self
        pageViewController.delegate = self
        return pageViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMe()
        configurePageView()
        setupScrollViewDelegate()
        setupUI()
        fetchMyStoryList()
    }
    
    func fetchMyStoryList() {
        playLoadingLottie()

        let myStoryListViewController = pageViewController.viewControllers?.first as? MyStoryListViewController
        myStoryListViewController?.fetchData { [weak self] in
            self?.stopLoadingLottie()
        }
    }

    private func setupUI() {
        let screenSize = UIScreen.main.bounds
        let lottieSize = screenSize.width * 0.35

        view.addSubview(fullDimView)
        fullDimView.alpha = 0
        fullDimView.frame = view.bounds
        fullDimView.addSubview(animationView)
        
        animationView.frame = CGRect(
            x: (screenSize.width - lottieSize) / 2,
            y: (screenSize.height - lottieSize) / 2,
            width: lottieSize,
            height: lottieSize
        )
        
        animationView.contentMode = .scaleAspectFill
        animationView.isUserInteractionEnabled = false
    }
    
    private func getMe() {
        loadingView.startAnimating()
        loadingView.isHidden = false
        
        viewModel.getMy { [weak self] result in
            switch result {
            case .success(let me):
                guard let me = me,
                      let self = self else {
                    return
                }
                self.nicknameLabel.text = me.nickname
                self.settingViewController.isAllowNotification = me.notification == true
            case .failure(let error):
                // TODO: error handling
                debugPrint(error.localizedDescription)
            }
            self?.loadingView.stopAnimating()
            self?.loadingView.isHidden = true
        }
    }
    
    private func playLoadingLottie() {
        animationView.play()
        
        UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) { [weak self] in
            self?.fullDimView.alpha = 1.0
        }.startAnimation()
    }
    
    private func stopLoadingLottie() {
        UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) { [weak self] in
            self?.fullDimView.alpha = 0
        }.startAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.animationView.stop()
        }
    }
    
    private func configurePageView() {
        addChild(pageViewController)
        containerView.addSubview(pageViewController.view)
        pageViewController.view.frame = containerView.bounds
        pageViewController.didMove(toParent: self)
        pages = [listViewController, settingViewController]
        listButton.isSelected = true
        
        if let firstViewController = pages.first {
            pageViewController.setViewControllers(
                [firstViewController],
                direction: .forward,
                animated: true,
                completion: nil
            )
        }
    }
    
    private func setupScrollViewDelegate() {
        let scrollView = containerView.subviews.first?.subviews.first as? UIScrollView
        scrollView?.delegate = self
    }
    
    @IBAction func listButtonDidTap(_ sender: UIButton) {
        changePageViewController(to: Page.list.index)
    }
    
    @IBAction func settingButtonDidTap(_ sender: UIButton) {
        changePageViewController(to: Page.setting.index)
    }
    
    private func changePageViewController(to index: Int) {
        guard pages.count > index,
              let selectedPage = pages[safe: index]
        else {
            return
        }
        
        let direction: UIPageViewController.NavigationDirection = currentPage < index ? .forward : .reverse
        
        pageViewController.setViewControllers(
            [selectedPage],
            direction: direction,
            animated: true,
            completion: nil
        )
        selectPage(index: index)
    }
    
    @IBAction private func closeButtonDidTap() {
        dismiss(animated: true)
    }
}

extension MyViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else {
            return nil
        }
        return pages[safe: index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else {
            return nil
        }
        return pages[safe: index + 1]
    }
}

extension MyViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?.first,
              let index = pages.firstIndex(of: viewController)
        else {
            return
        }
        selectPage(index: index)
    }
    
    private func selectPage(index: Int) {
        guard index < pages.count else {
            return
        }
        let isList = Page(rawValue: index) == .list
        
        listButton.isSelected = isList
        settingButton.isSelected = !isList
        
        currentPage = index
        
        UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) { [weak self] in
            guard let self = self else {
                return
            }
            self.buttonBackgroundListLeadingConstraint.constant = isList ? 0 : Constant.buttonWidth + Constant.stackViewSpacing
            self.buttonBackgroundListTrailingConstraint.constant = isList ? 0 : Constant.buttonWidth + Constant.stackViewSpacing
            self.view.layoutIfNeeded()
        }.startAnimation()
    }
}

extension MyViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        listViewController.hiddenScrollViewIndicator(isHidden: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        listViewController.hiddenScrollViewIndicator(isHidden: false)
    }
}

extension MyViewController {
    private enum Page: Int {
        case list = 0
        case setting
        
        var index: Int {
            return self.rawValue
        }
    }
    
    private enum Constant {
        static let buttonWidth: CGFloat = 89.0
        static let stackViewSpacing: CGFloat = 9.0
    }
}
