//
//  NicknameRequest.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/08/02.
//

import Foundation

struct GetNicknameRequest: Codable {
    let adjective: String?
    let noun: String?
}

struct PostNicknameRequest: Codable {
    let adjective: String
    let noun: String
}
