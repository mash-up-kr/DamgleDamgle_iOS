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

    func setupUI(viewModel: PostModel) {
        placeAddressLabel.text = "ERROR"
        userNameLabel.text = viewModel.userName
        checkMeLabel.text = viewModel.isChecked ? " • ME" : ""
        timeLabel.text = viewModel.timeText
    }
}
