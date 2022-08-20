//
//  PostViewController.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/12.
//

import UIKit

final class PostViewController: UIViewController {
    @IBOutlet weak var shortenBackgroundImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var shortenBackgroundImageView: UIView!
    @IBOutlet private weak var myStoryGuideLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var postingTextView: UITextView!
    @IBOutlet private weak var textViewOverLimitButton: UIButton!
    @IBOutlet private var postingComponents: [UIView]!
    @IBOutlet private weak var currentTextCountLabel: UILabel!
    @IBOutlet private weak var swipeDownGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet private weak var swipeUpGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet private weak var postButton: ContinueButton!
    
    private let maxTextLength = 100
    private let swipeUpHeightRatio = 0.05
    private let swipeDownHeightRatio = 0.86
    private var textViewWordCount: Int = 0 {
        didSet {
            currentTextCountLabel.text = "\(textViewWordCount)"
            postButton.isEnabled = textViewWordCount > 0
        }
    }
    private var textViewStatus: TextViewStatus = .placeholder {
        didSet {
            switch textViewStatus {
            case .placeholder:
                textViewWordCount = 0
                postingTextView.text = StringResource.textViewPlaceholder
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
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) { [weak self] in
            guard let self = self else {
                return
            }

            switch sender.direction {
            case .up:
                self.updateAnimatingView(heightRatio: self.swipeUpHeightRatio, direction: sender.direction)
            case .down:
                self.postingTextView.resignFirstResponder()
                self.updateAnimatingView(heightRatio: self.swipeDownHeightRatio, direction: sender.direction)
            default:
                break
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) {
                switch sender.direction {
                case .down:
                    self.myStoryGuideLabel.isHidden = false
                    self.shortenBackgroundImageView.isHidden = false
                    self.myStoryGuideLabel.alpha = 1
                    self.shortenBackgroundImageView.alpha = 1
                default:
                    break
                }
            }
        }
    }
    
    func updateAnimatingView(heightRatio: Double = 0.05, direction: UISwipeGestureRecognizer.Direction = .up) {
        let originHeight: CGFloat = UIScreen.main.bounds.height
        let transformHeight = originHeight * 0.81

        switch direction {
        case .up:
            let transform = CGAffineTransform(scaleX: 1, y: 1).translatedBy(x: 0, y: -transformHeight)
            view.transform = transform
            
            myStoryGuideLabel.isHidden = true
            myStoryGuideLabel.alpha = 0
            shortenBackgroundImageView.isHidden = true
            shortenBackgroundImageView.alpha = 0
            
            postingComponents.forEach {
                $0.alpha = 1
            }
        case .down:
            let transform: CGAffineTransform = .identity
            view.transform = transform
            
            postingComponents.forEach {
                $0.alpha = 0
            }
        default:
            break
        }
        
        self.view.layoutIfNeeded()
        
        [swipeUpGestureRecognizer, swipeDownGestureRecognizer].forEach {
            $0?.isEnabled.toggle()
        }
    }
    
    @IBAction private func backgroundTapped(_ sender: UITapGestureRecognizer) {
        self.postingTextView.resignFirstResponder()
    }
    
    @IBAction private func postButtonTapped(_ sender: UIButton) {
        showAlertController(
            type: .double,
            title: StringResource.title,
            message: StringResource.message,
            okActionTitle: StringResource.okTitle,
            okActionHandler: {
                self.viewModel.postStory { result in
                    let postProcessViewController = PostProcessViewController.instantiate()
                    postProcessViewController.modalPresentationStyle = .fullScreen
                    postProcessViewController.postStatus = result == true ? .success : .fail
                    self.present(postProcessViewController, animated: true)
                }
            },
            cancelActionTitle: StringResource.cancelTitle
        )
    }
    
// MARK: - UDF
    func setUpView() {
        let startColor = UIColor(named: "grey500") ?? .gray
        let endColor = UIColor(named: "gradientOrange") ?? .orange
        shortenBackgroundImageView.addGradientLayer(startColor: startColor, endColor: endColor)
        shortenBackgroundImageViewHeightConstraint.constant = UIScreen.main.bounds.height * 0.14
        
        myStoryGuideLabel.isHidden = false
        textViewOverLimitButton.isHidden = true
        postingComponents.forEach {
            $0.alpha = 0
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
    private enum StringResource {
        static let title = "담글을 이대로 남기시겠어요?"
        static let message = "이번달 말에 담벼락이 지워지기 전까지 해당 글을 수정 · 삭제할 수 없어요!"
        static let okTitle = "이대로 남기기"
        static let cancelTitle = "다시 확인하기"
        static let textViewPlaceholder = "지도 담벼락에 나만의 글을 남겨보세요."
    }
    
    private enum TextViewStatus {
        case placeholder
        case editing
    }
}

// MARK: - TextView Delegate
extension PostViewController: UITextViewDelegate {
    // TODO: 추후 개선 예정
    func textViewDidChange(_ textView: UITextView) {
        let textCount = textView.text.textCountWithoutSpacingAndLines
        textViewWordCount = textCount
        viewModel.postContent = textView.text
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == StringResource.textViewPlaceholder {
            textViewStatus = .editing
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textViewStatus = .placeholder
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return true
          } else {
          let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
          let numberOfText = newText.textCountWithoutSpacingAndLines
          let isUnderLimit = numberOfText <= maxTextLength
          textViewOverLimitButton.isHidden = isUnderLimit
          return isUnderLimit
        }
    }
}
