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
    @IBOutlet private weak var currentTextCountLabel: UILabel!
    @IBOutlet private var swipeDownGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet private var swipeUpGestureRecognizer: UISwipeGestureRecognizer!
    
    private let swipeUpHeightRatio = 0.05
    private let swipeDownHeightRatio = 0.85
    private var textViewWordCount: Int = 0 {
        didSet {
            currentTextCountLabel.text = "\(textViewWordCount)"
        }
    }
    private var textViewStatus: TextViewStatus = .placeholder {
        didSet {
            switch textViewStatus {
            case .placeholder:
                textViewWordCount = 0
                postingTextView.text = StringResource.textViewPlaceholder.rawValue
                postingTextView.textColor = UIColor(named: "grey600")
            case .editing:
                postingTextView.text = nil
                postingTextView.textColor = UIColor(named: "black")
            }
        }
    }
    
    private let viewModel = PostViewModel()
    
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
            
            [swipeUpGestureRecognizer, swipeDownGestureRecognizer].forEach {
                $0?.isEnabled.toggle()
            }
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
            title: StringResource.title.rawValue,
            message: StringResource.message.rawValue,
            okActionTitle: StringResource.okTitle.rawValue,
            okActionHandler: {
                // TODO: Post API 연결
                let postProcessViewController = PostProcessViewController.instantiate()
                postProcessViewController.modalPresentationStyle = .fullScreen
                postProcessViewController.postStatus = .success
                self.present(postProcessViewController, animated: true)
            },
            cancelActionTitle: StringResource.cancelTitle.rawValue
        )
    }
    
// MARK: - UDF
    func setUpView() {
        myStoryGuideLabel.isHidden = false
        textViewOverLimitButton.isHidden = true
        postingComponents.forEach {
            $0.isHidden = true
        }
        swipeUpGestureRecognizer.isEnabled = true
        swipeDownGestureRecognizer.isEnabled = false
        
        postingTextView.text = ""
        textViewStatus = .placeholder
        
        postingTextView.delegate = self
        
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
}

// MARK: - Enum
extension PostViewController {
    private enum StringResource: String {
        case title = "담글을 이대로 남기시겠어요?"
        case message = "이번달 말에 담벼락이 지워지 전까지 해당 글을 수정 · 삭제할 수 없어요!"
        case okTitle = "이대로 남기기"
        case cancelTitle = "다시 확인하기"
        case textViewPlaceholder = "지도 담벼락에 나만의 글을 남겨보세요."
    }
    
    private enum TextViewStatus {
        case placeholder
        case editing
    }
}

// MARK: - TextView Delegate
extension PostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textViewWordCount = textView.text.count
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == StringResource.textViewPlaceholder.rawValue {
            textViewStatus = .editing
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textViewStatus = .placeholder
        }
    }
    
    // TODO: 글자수 제한 로직 구현
    // TODO: 글자수에 따라 button 활성화, 비활성화 처리
}
