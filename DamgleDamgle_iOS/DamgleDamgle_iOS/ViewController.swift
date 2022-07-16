//
//  ViewController.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/06/25.
//

import UIKit

final class ViewController: UIViewController {

    @IBAction private func myButtonDidTap() {
        let myViewController = MyViewController.instantiate()
        myViewController.modalPresentationStyle = .overFullScreen
        present(myViewController, animated: true)
    }
}

