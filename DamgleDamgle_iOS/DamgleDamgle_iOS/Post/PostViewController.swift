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
    @IBOutlet private weak var postingTextView: UITextView!
    @IBOutlet private weak var textViewOverLimitButton: UIButton!
    @IBOutlet private var postingComponents: [UIView]!
    
    private let swipeUpHeightRatio = 0.05
    private let swipeDownHeightRatio = 0.85
    
// MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
// MARK: - @IBAction
    @IBAction private func swipeUpDown(_ sender: UISwipeGestureRecognizer) {
        let originWidth: CGFloat = UIScreen.main.bounds.width
        let originHeight: CGFloat = UIScreen.main.bounds.height
        
        func updateAnimatingView(heightRatio: Double) {
            self.view.frame = CGRect(
                x: 0,
                y: originHeight * heightRatio,
                width: originWidth,
                height: originHeight * (1 - heightRatio)
            )
            self.myStoryGuideLabel.isHidden.toggle()
            self.postingComponents.forEach {
                $0.isHidden.toggle()
            }
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.3) {
            switch sender.direction {
            case .up:
                updateAnimatingView(heightRatio: self.swipeUpHeightRatio)
            case .down:
                self.postingTextView.resignFirstResponder()
                updateAnimatingView(heightRatio: self.swipeDownHeightRatio)
            default:
                break
            }
        }
    }
    
    @IBAction private func backgroundTapped(_ sender: UITapGestureRecognizer) {
        self.postingTextView.resignFirstResponder()
    }
    
    @IBAction private func postButtonTapped(_ sender: UIButton) {
        showAlertController(
            type: .double,
            title: PostViewStringResource.title.rawValue,
            message: PostViewStringResource.message.rawValue,
            okActionTitle: PostViewStringResource.okTitle.rawValue,
            okActionHandler: {
                // TODO: Post API 연결
                let postProcessViewController = PostProcessViewController.instantiate()
                postProcessViewController.modalPresentationStyle = .fullScreen
                postProcessViewController.postStatus = .success
                self.present(postProcessViewController, animated: true)
            },
            cancelActionTitle: PostViewStringResource.cancelTitle.rawValue
        )
    }
    
// MARK: - UDF
    func setUpView() {
        myStoryGuideLabel.isHidden = false
        textViewOverLimitButton.isHidden = true
        postingComponents.forEach {
            $0.isHidden = true
        }
        postingTextView.text = ""
        
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
}

extension PostViewController {
    enum PostViewStringResource: String {
        case title = "담글을 이대로 남기시겠어요?"
        case message = "이번달 말에 담벼락이 지워지 전까지 해당 글을 수정 · 삭제할 수 없어요!"
        case okTitle = "이대로 남기기"
        case cancelTitle = "다시 확인하기"
    }
}
