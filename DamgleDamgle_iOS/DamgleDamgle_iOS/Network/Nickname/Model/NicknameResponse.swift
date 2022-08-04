//
//  NicknameResponse.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/08/02.
//

import Foundation

struct NicknameResponse: Codable {
    let name: String
    let adjective: String
    let noun: String
    let nth: Int
}
