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
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        loadNicknameResponce()
    }
    
    private func loadNicknameResponce() {
        self.activityIndicatorView.startAnimating()
        self.viewModel.getNickname() { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.setupUI()
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    private func setupUI() {
        guard let model = self.viewModel.model else { return }
        orderNumLabel.text = "\(model.nth)" + "번째"
        adjectiveLabel.text = model.adjective
        nounLabel.text = model.noun
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
                    if isSuccess {
                        guard let self = self else { return }
                        self.showHomeView()
                    } else {
                        
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
                self.setupUI()
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    @IBAction private func nounChangeButtonDidTap(_ sender: UIButton) {
        self.activityIndicatorView.startAnimating()
        self.viewModel.changeNoun() { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.setupUI()
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
}
