//
//  NicknameRequest.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/08/02.
//

import Foundation

struct GetNicknameRequest {
    let adjective: String?
    let noun: String?
}

struct PostNicknameRequest {
    let adjective: String
    let noun: String
}
