//
//  CommonStringResource.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/23.
//

import Foundation

enum CommonStringResource: String {
    case noLocationAuthorization
    
    var title: String {
        switch self {
        case .noLocationAuthorization:
            return "위치정보 이용에 대한 엑세스 권한이 없어요"
        }
    }
    
    var message: String {
        switch self {
        case .noLocationAuthorization:
            return "설정으로 이동해서 권한을 변경해주세요!"
        }
    }
}
