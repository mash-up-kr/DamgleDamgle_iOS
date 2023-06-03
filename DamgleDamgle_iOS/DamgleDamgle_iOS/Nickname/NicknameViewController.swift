//
//  NicknameViewController.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/13.
//

import UIKit
import Lottie

final class NicknameViewController: UIViewController, StoryboardBased {
    static var storyboard: UIStoryboard {
        UIStoryboard(name: "Nickname", bundle: nil)
    }
    
    @IBOutlet private weak var orderNumLabel: UILabel!
    @IBOutlet private weak var adjectiveLabel: UILabel!
    @IBOutlet private weak var nounLabel: UILabel!
    @IBOutlet private weak var changeAdjectiveButton: UIButton!
    @IBOutlet private weak var changeNameButton: UIButton!
    @IBOutlet private weak var adjectiveIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var nounIndicatorView: UIActivityIndicatorView!

    private var viewModel = NicknameViewModel()
    private let fullDimView = FullDimView()
    private let refreshLottieName = "refreshLottie"
    
    private lazy var animationView = Lottie.AnimationView(name: refreshLottieName)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLottieView()
        setupView(viewModel: NicknameResponse(name: "", adjective: "로딩중인", noun: "담글이", nth: Int.random(in: 0...99)))
        fetchNicknameResponce()
    }
    
    private func setupView(viewModel: NicknameResponse) {
        orderNumLabel.text = "\(viewModel.nth)" + "번째"
        adjectiveLabel.text = viewModel.adjective
        nounLabel.text = viewModel.noun
    }
    
    private func setupLottieView() {
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
    
    private func fetchNicknameResponce() {
        playLoadingLottie()
        
        self.viewModel.getNickname() { [weak self] _ in
            guard let self = self, let viewModel = self.viewModel.model else { return }
            self.setupView(viewModel: viewModel)
            self.stopLoadingLottie()
        }
    }
    
    private func showHomeView() {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        
        guard let keyWindow = keyWindow else {
            return
        }
        
        DispatchQueue.main.async {
            UIView.transition(with: keyWindow, duration: 0.3, options: .transitionCrossDissolve, animations: {
                let homeViewController = HomeViewController()
                keyWindow.rootViewController = homeViewController
            })
        }
    }
    
    @IBAction private func startButtonDidTap(_ sender: UIButton) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async { [weak self] in
                let authorizedState = settings.authorizationStatus == .authorized
                self?.viewModel.postNickname(isNotificationEnabled: authorizedState) { [weak self] isSuccess in
                    guard let self = self else { return }
                    
                    if isSuccess {
                        self.showHomeView()
                    } else {
                        self.showAlertController(
                            type: .double,
                            title: Strings.title,
                            message: Strings.message,
                            okActionTitle: Strings.okTitle,
                            okActionHandler: nil
                        )
                    }
                }
            }
        }
    }
    
    @IBAction private func adjectiveChangeButtonDidTap(_ sender: UIButton) {
        adjectiveIndicatorView.startAnimating()
        viewModel.changeAdjective() { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard let viewModel = self.viewModel.model else { return }
                self.setupView(viewModel: viewModel)
                self.adjectiveIndicatorView.stopAnimating()
            }
        }
    }
    
    @IBAction private func nounChangeButtonDidTap(_ sender: UIButton) {
        nounIndicatorView.startAnimating()
        viewModel.changeNoun() { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard let viewModel = self.viewModel.model else { return }
                self.setupView(viewModel: viewModel)
                self.nounIndicatorView.stopAnimating()
            }
        }
    }
    
    @IBAction private func informationButtonDidTap(_ sender: UIButton) {
        showAlertController(
            type: .single,
            title: String(format: Strings.informateionTitleFormat, orderNumLabel.text ?? "n번째"),
            message: Strings.informateionMessage
        )
    }
}

extension NicknameViewController {
    private enum Strings {
        static let title = "네트워크가 불안정해요."
        static let message = "지금은 내용을 불러오기 어려워요.\n잠시 후에 다시 시도해주세요."
        static let okTitle = "확인"
        static let informateionTitleFormat = "%@는 나와 같은 닉네임의 개수를 뜻해요."
        static let informateionMessage = "운이 좋다면 첫 번째 닉네임을 찾을 수 있어요. 행운을 빌어요!"
    }
}
