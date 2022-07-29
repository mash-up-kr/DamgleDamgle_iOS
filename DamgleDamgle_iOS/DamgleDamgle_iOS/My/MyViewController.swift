//
//  MyViewController.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/16.
//

import UIKit

final class MyViewController: UIViewController, StoryboardBased {
    static var storyboard: UIStoryboard {
        UIStoryboard(name: "My", bundle: nil)
    }
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var listButton: UIButton!
    @IBOutlet private weak var settingButton: UIButton!

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
        
        configurePageView()
    }
    
    private func configurePageView() {
        let listViewController = MyStoryListViewController.instantiate()
        let settingViewController = SettingViewController.instantiate()
        
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

    @IBAction func listButtonDidTap(_ sender: UIButton) {
        listButton.isSelected = true
        settingButton.isSelected = false
        changePageViewController(to: Page.list.index)
    }

    @IBAction func settingButtonDidTap(_ sender: UIButton) {
        listButton.isSelected = false
        settingButton.isSelected = true
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
        listButton.isSelected = index == Page.list.index
        settingButton.isSelected = index == Page.setting.index
        currentPage = index
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
}
