//
//  NicknameViewController.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/13.
//

import UIKit

final class NicknameViewController: UIViewController, StoryboardBased {
    static var storyboard: UIStoryboard {
        UIStoryboard(name: "Nickname", bundle: nil)
    }
    
    @IBOutlet private weak var orderNumLabel: UILabel!
    @IBOutlet private weak var adjectiveLabel: UILabel!
    @IBOutlet private weak var nounLabel: UILabel!
    @IBOutlet private weak var changeAdjectiveButton: UIButton!
    @IBOutlet private weak var changeNameButton: UIButton!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    private var viewModel = NicknameViewModel()
    private let refreshLottieName = "refreshLottie"
    private let lottieSize = UIScreen.main.bounds.width * 0.35
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView(viewModel: NicknameResponse(name: "", adjective: "로딩중인", noun: "담글이", nth: Int.random(in: 0...99)))
        loadNicknameResponce()
        addLottieAnimation(
            lottieName: self.refreshLottieName,
            lottieSize: self.lottieSize,
            isNeedDimView: true
        )
    }
    
    private func loadNicknameResponce() {
        self.viewModel.getNickname() { [weak self] _ in
            guard let self = self, let viewModel = self.viewModel.model else { return }
            self.setupView(viewModel: viewModel)
        }
    }
    
    private func setupView(viewModel: NicknameResponse) {
        orderNumLabel.text = "\(viewModel.nth)" + "번째"
        adjectiveLabel.text = viewModel.adjective
        nounLabel.text = viewModel.noun
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
        // TODO: 회원가입시키고 accessToken받아서 UserManager에 저장, 아래가 방법 예시!
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async { [weak self] in
                // TODO: 서버 값이랑 동기화 할지? 로컬이랑 동기화 할지?
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
        self.activityIndicatorView.startAnimating()
        self.viewModel.changeAdjective() { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard let viewModel = self.viewModel.model else { return }
                self.setupView(viewModel: viewModel)
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    @IBAction private func nounChangeButtonDidTap(_ sender: UIButton) {
        self.activityIndicatorView.startAnimating()
        self.viewModel.changeNoun() { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard let viewModel = self.viewModel.model else { return }
                self.setupView(viewModel: viewModel)
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
}

extension NicknameViewController {
    private enum Strings {
        static let title = "네트워크가 불안정해요."
        static let message = "지금은 내용을 불러오기 어려워요.\n잠시 후에 다시 시도해주세요."
        static let okTitle = "확인"
    }
}
