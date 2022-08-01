//
//  AuthResponse.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/08/01.
//

import Foundation

struct SigningResponse: Decodable {
    let nickname: String
    let userNo: Int
    let notification: Bool
    let accessToken: String
    let refreshToken: String
}

struct GetPatchMyInfoResponse: Decodable {
    let nickname: String
    let userNo: Int
    let notification: Bool
}

struct DeleteMyInfoResponse: Decodable {
    let message: String
}

