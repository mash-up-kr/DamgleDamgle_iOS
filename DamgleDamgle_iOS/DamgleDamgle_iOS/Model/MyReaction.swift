//
//  ReactionOfMine.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/08/20.
//

import Foundation

struct MyReaction: Decodable, Hashable {
    let userNo: Int
    let nickname: String
    let type: String
}
