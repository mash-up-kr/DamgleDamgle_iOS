//
//  SignUpRequest.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/31.
//

import Foundation

struct PostSignUpRequest {
    let nickname: String
    let isNotificationEnabled: Bool
}

struct PostSignInRequest {
    let userNo: Int
    let refreshToken: String
}
