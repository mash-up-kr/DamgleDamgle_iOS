//
//  APIStatus.swift
//  DamgleDamgle_iOS
//
//  Created by 최원석 on 2022/08/09.
//

import Foundation

enum APIStatus: Int {
    case success = 200
    case requestError = 400
    case tokenError = 403
    case responseError = 404
    case serverError = 500
}
