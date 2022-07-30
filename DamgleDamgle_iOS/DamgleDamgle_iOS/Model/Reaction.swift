//
//  Reaction.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/29.
//

import Foundation

struct Reaction: Decodable, Hashable {
    let userNo: Int
    let nickname: String
    let type: String
}
