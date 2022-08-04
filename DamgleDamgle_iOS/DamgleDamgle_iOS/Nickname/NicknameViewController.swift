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
    
    private var viewModel = NicknameViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
    }
    
    private func setupUI() {
        guard let model = self.viewModel.model else { return }
        orderNumLabel.text = "\(model.nth)" + "번째"
        adjectiveLabel.text = model.adjective
        nounLabel.text = model.noun
    }
    
    // MARK: - lnterface Links
    @IBOutlet private weak var orderNumLabel: UILabel!
    @IBOutlet private weak var adjectiveLabel: UILabel!
    @IBOutlet private weak var nounLabel: UILabel!
    @IBOutlet private weak var changeAdjectiveButton: UIButton!
    @IBOutlet private weak var changeAnimalNameButton: UIButton!
    
    @IBAction private func startButtonDidTap(_ sender: UIButton) {
        // TODO: 회원가입시키고 accessToken받아서 UserManager에 저장, 아래가 방법 예시!
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async { [weak self] in
                // TODO: 서버 값이랑 동기화 할지? 로컬이랑 동기화 할지?
                let authorizedState = settings.authorizationStatus == .authorized
                self?.viewModel.signUp(isNotificationEnabled: authorizedState) { _ in
                    let viewController = HomeViewController()
                    UIApplication.shared.windows.first?.rootViewController = viewController
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
            }
        }
    }
    
    @IBAction private func adjectiveChangeButtonDidTap(_ sender: UIButton) {
        viewModel.changeAdjective()
    }
    
    @IBAction private func nounChangeButtonDidTap(_ sender: UIButton) {
        viewModel.changeNoun()
    }
}

extension NicknameViewController: NicknameViewModelDelegate {
    func bind() {
        setupUI()
    }
}
