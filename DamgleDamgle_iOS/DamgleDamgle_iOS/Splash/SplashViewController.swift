//
//  SplashViewController.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/27.
//

import Lottie
import UIKit

final class SplashViewController: UIViewController, StoryboardBased {
    static var storyboard: UIStoryboard {
        UIStoryboard(name: "Splash", bundle: nil)
    }
    
    @IBOutlet private weak var lottieView: UIView!
    
    private let paintLottieName = "splash"

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startLottie()
    }
    
    private func startLottie() {
        let animationView = Lottie.AnimationView(name: paintLottieName)
        lottieView.addSubview(animationView)
        animationView.frame = lottieView.bounds
        animationView.contentMode = .scaleAspectFit

        DispatchQueue.main.async {
            animationView.play { [weak self] _ in
                self?.showHomeView()
            }
        }
    }
    
    private func showHomeView() {
        let homeViewController = HomeViewController()
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }

        guard let keyWindow = keyWindow else {
            return
        }
        
        DispatchQueue.main.async {
            UIView.transition(with: keyWindow, duration: 0.3, options: .transitionCrossDissolve, animations: {
                keyWindow.rootViewController = homeViewController
            })
        }
    }
}
