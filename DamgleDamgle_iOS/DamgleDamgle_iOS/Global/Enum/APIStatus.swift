//
//  APIStatus.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/08/09.
//

import Foundation

enum APIStatus: Int {
    case success = 200
    case existingNickname = 400
    case tokenError = 401
    case serverError = 500
    case clientError = 501
}
