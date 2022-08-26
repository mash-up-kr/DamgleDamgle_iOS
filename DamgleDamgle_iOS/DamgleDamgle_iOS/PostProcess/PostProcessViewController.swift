//
//  PostProcessViewController.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/17.
//

import Lottie
import UIKit

enum ViewType {
    case setting
    case home
}

protocol PostProcessDismissProtocol: AnyObject {
    func dismissToMain()
    func dismissToPost()
}

final class PostProcessViewController: UIViewController, StoryboardBased {
    static var storyboard: UIStoryboard {
        UIStoryboard(name: "PostProcess", bundle: nil)
    }
    
    weak var delegate: PostProcessDismissProtocol?
        
    @IBOutlet private weak var processStatusTitleLabel: UILabel!
    @IBOutlet private weak var processStatusSubTitleLabel: UILabel!
    @IBOutlet private weak var processImageView: UIImageView!
    @IBOutlet private weak var nextStepButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    
    var postStatus: PostStatus = .inProgress
    var viewType: ViewType = .home
    
    private let viewModel = PostProcessViewModel()
    private let successLottieName = "write_success"
    private let failLottieName = "write_fail"
    private let lottieSize = UIScreen.main.bounds.width * 0.9
    
// MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLottie()
    }

// MARK: - @IBAction
    @IBAction private func nextStepButtonDidTap(_ sender: UIButton) {
        switch postStatus {
        case .inProgress:
            break
        case .success:
            presentMyNewStoryView()
            break
        case .fail:
            dismiss()
        }
    }
    
    @IBAction private func closeButtonDidTap(_ sender: UIButton) {
        dismiss()
    }
   
// MARK: - UDF
    private func setUpView() {
        updateViewData(type: .inProgress)
    }
    
    private func updateViewData(type: PostStatus) {
        processStatusTitleLabel.text = type.statusTitle
        processStatusSubTitleLabel.text = type.subTitle
        
        if let image = type.image {
            processImageView.image = image
        }
        
        processImageView.image = type.image
        
        if let buttonTitle = type.buttonTitle {
            nextStepButton.isHidden = false
            nextStepButton.setTitle(buttonTitle, for: .normal)
        } else {
            nextStepButton.isHidden = true
        }
        
        let isCloseButtonHidden = type == .inProgress
        closeButton.isHidden = isCloseButtonHidden
    }
    
    private func showLottie() {
        var currentLottieName: String
        currentLottieName = postStatus == .success ? successLottieName : failLottieName
        
        addLottieAnimation(
            lottieName: currentLottieName,
            lottieSize: lottieSize,
            isNeedDimView: false) {
                self.updateViewData(type: self.postStatus)
            }
    }
    
    private func dismiss() {
        if viewType == .home {
            let presentingViewController = self.presentingViewController as? HomeViewController
            presentingViewController?.dismiss(animated: true)
        } else {
            let presentingViewController = self.presentingViewController
            let myViewController = presentingViewController?.presentingViewController as? MyViewController

            dismiss(animated: false) {
                presentingViewController?.dismiss(animated: true) {
                    myViewController?.fetchMyStoryList()
                }
            }
        }
    }
    
    private func presentMyNewStoryView() {
        if viewType == .home {
            presentMyNewStoryViewWhenHome()
        } else {
            presentMyNewStoryViewWhenMyPage()
        }
    }
    
    private func presentMyNewStoryViewWhenHome() {
        let homeViewController = presentingViewController
        
        dismiss(animated: false) { [weak self] in

                self?.viewModel.fetchData { story in
                    let postingMainNavigationViewController = PostingNavigationController.instantiate()

                    guard let story = story,
                          let postingMainViewController = postingMainNavigationViewController.viewControllers.first as? PostingMainViewController
                    else {
                        return
                    }
                    
                    postingMainViewController.viewModel.postModels = [story]
                    postingMainNavigationViewController.modalPresentationStyle = .overFullScreen
                    homeViewController?.present(postingMainNavigationViewController, animated: true)
                }
        }
    }
    
    private func presentMyNewStoryViewWhenMyPage() {
        let postViewController = presentingViewController as? PostViewController
        let myViewController = presentingViewController?.presentingViewController as? MyViewController
        
        dismiss(animated: false) { [weak self] in
            postViewController?.view.isHidden = true
            postViewController?.dismiss(animated: false) {

                self?.viewModel.fetchData { story in
                    let postingMainNavigationViewController = PostingNavigationController.instantiate()

                    guard let story = story,
                          let postingMainViewController = postingMainNavigationViewController.viewControllers.first as? PostingMainViewController
                    else {
                        return
                    }
                    
                    postingMainViewController.viewModel.postModels = [story]
                    postingMainNavigationViewController.modalPresentationStyle = .overFullScreen
                    myViewController?.present(postingMainNavigationViewController, animated: true)
                    myViewController?.fetchMyStoryList()
                }
            }
        }
    }
}
