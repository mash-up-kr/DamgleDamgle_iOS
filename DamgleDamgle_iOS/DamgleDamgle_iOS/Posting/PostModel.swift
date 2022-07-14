//
//  PostModel.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/07/03.
//

import Foundation

struct PostModel: Identifiable {
    var id: Int
    var placeAddress: String
    var timeText: String
    var content: String
    var userName: String
    var isChecked: Bool
    var icon: IconsButton?
}
