//
//  PostErrorTableViewCell.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/29.
//

import UIKit

final class PostErrorTableViewCell: UITableViewCell, Reusable {

    @IBOutlet private weak var placeAddressLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var checkMeLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!

    func setupUI() {
        placeAddressLabel.text = "ERROR"
        userNameLabel.text = "아쉬운 11번째 코알라"
        checkMeLabel.text = " • ME"
        timeLabel.text = "N분 전"
    }
}
