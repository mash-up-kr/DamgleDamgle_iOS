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

    func setupView() {
        placeAddressLabel.text = Strings.placeAddressTitle
        userNameLabel.text = Strings.userNameTitle
        checkMeLabel.text = Strings.checkMeTitle
        timeLabel.text = Strings.timeTitle
    }
}

extension PostErrorTableViewCell {
    enum Strings {
        static let placeAddressTitle = "ERROR"
        static let userNameTitle = "아쉬운 11번째 코알라"
        static let checkMeTitle = " • ME"
        static let timeTitle = "N분 전"
    }
}
