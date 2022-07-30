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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - lnterface Links
    @IBOutlet private weak var orderNumLabel: UILabel!
    @IBOutlet private weak var adjectiveLabel: UILabel!
    @IBOutlet private weak var animalNameLabel: UILabel!
    @IBOutlet private weak var changeAdjectiveButton: UIButton!
    @IBOutlet private weak var changeAnimalNameButton: UIButton!
    
    @IBAction private func startButtonDidTap(_ sender: UIButton) {
        // TODO: 회원가입시키고 accessToken받아서 UserManager에 저장
        let viewController = HomeViewController()
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
